$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..")
$LegacySkillsFile = Join-Path $ScriptDir "legacy-skills.txt"

function Show-Usage {
@"
Usage: prune-skills.ps1 [--user|--repo|--path <dir>] [--agents] [--dry-run]

Removes (backs up) legacy non-vc skills from older vibe-codex installs.
Only affects skill directories listed in scripts/legacy-skills.txt.

  --user        Use user skills scope (default)
                - default: `$CODEX_HOME\\skills (legacy-compatible)
                - with --agents: ~\\.agents\\skills (Codex docs default)
  --repo        Use repo skills scope (from current directory)
                - default: <git-root>\\.codex\\skills
                - with --agents: <git-root>\\.agents\\skills
  --path <dir>  Use an explicit skills directory
  --agents      Use .agents\\skills locations for --user/--repo
  --dry-run     Print what would change, but don't move anything
"@ | Write-Output
}

if (-not (Test-Path $LegacySkillsFile)) {
  Write-Error "Error: missing legacy skills list: $LegacySkillsFile"
  exit 1
}

function Get-LegacySkills {
  return Get-Content $LegacySkillsFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not $_.StartsWith("#") }
}

$Scope = "user"
$CustomDest = $null
$UseAgents = $false
$DryRun = $false
for ($i = 0; $i -lt $Args.Length; $i++) {
  switch ($Args[$i]) {
    "--user" { $Scope = "user" }
    "--repo" { $Scope = "repo" }
    "--agents" { $UseAgents = $true }
    "--path" {
      if ($i + 1 -ge $Args.Length) {
        Write-Error "Error: --path requires a directory."
        Show-Usage
        exit 1
      }
      $CustomDest = $Args[$i + 1]
      $i++
    }
    "--dry-run" { $DryRun = $true }
    "-h" { Show-Usage; exit 0 }
    "--help" { Show-Usage; exit 0 }
    default {
      Write-Error ("Error: unknown option: " + $Args[$i])
      Show-Usage
      exit 1
    }
  }
}

if ($CustomDest) {
  if ([System.IO.Path]::IsPathRooted($CustomDest)) {
    $DestDir = $CustomDest
  } else {
    $DestDir = Join-Path $PWD.Path $CustomDest
  }
} elseif ($Scope -eq "repo") {
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Error: git is required for --repo."
    exit 1
  }
  $repoRoot = git -C $PWD.Path rev-parse --show-toplevel 2>$null
  if (-not $repoRoot) {
    Write-Error "Error: not inside a git repo. Use --path or run inside a repo."
    exit 1
  }
  if ($UseAgents) {
    $DestDir = Join-Path $repoRoot.Trim() ".agents\\skills"
  } else {
    $DestDir = Join-Path $repoRoot.Trim() ".codex\\skills"
  }
} else {
  if ($UseAgents) {
    $DestDir = Join-Path $HOME ".agents\\skills"
  } else {
    $DestRoot = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
    $DestDir = Join-Path $DestRoot "skills"
  }
}

if (-not (Test-Path $DestDir)) {
  Write-Error "Skills dir not found: $DestDir"
  exit 1
}

$legacy = Get-LegacySkills

$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$backupDir = $null
$removed = 0

foreach ($name in $legacy) {
  $dest = Join-Path $DestDir $name
  if (-not (Test-Path $dest)) {
    continue
  }
  if ($DryRun) {
    Write-Output "Would move: $dest"
    $removed++
    continue
  }
  if (-not $backupDir) {
    $backupDir = Join-Path (Split-Path $DestDir -Parent) ("skills.bak-" + $timestamp)
    New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
  }
  Move-Item $dest $backupDir
  $removed++
}

if ($DryRun) {
  Write-Output "Dry run complete. Would remove $removed skill(s) from $DestDir."
  exit 0
}

Write-Output "Removed $removed legacy skill(s) from $DestDir."
if ($backupDir) {
  Write-Output "Backup dir: $backupDir"
}
