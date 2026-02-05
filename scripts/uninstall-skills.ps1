$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$CoreSkillsFile = Join-Path $ScriptDir "core-skills.txt"

function Show-Usage {
@"
Usage: uninstall-skills.ps1 [--user|--repo|--path <dir>] [--agents]

Removes (backs up) core vc skills from an installed skills directory.

  --user        Use user skills scope (default)
                - default: `$CODEX_HOME\\skills (legacy-compatible)
                - with --agents: ~\\.agents\\skills (Codex docs default)
  --repo        Use repo skills scope (from current directory)
                - default: <git-root>\\.codex\\skills
                - with --agents: <git-root>\\.agents\\skills
  --path <dir>  Use an explicit skills directory
  --agents      Use .agents\\skills locations for --user/--repo
"@ | Write-Output
}

if (-not (Test-Path $CoreSkillsFile)) {
  Write-Error "Error: missing core skills list: $CoreSkillsFile"
  exit 1
}

function Get-CoreSkills {
  return Get-Content $CoreSkillsFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not $_.StartsWith("#") }
}

$Scope = "user"
$CustomDest = $null
$UseAgents = $false
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

$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$BackupDir = $null
$removed = 0

$coreSkills = Get-CoreSkills
foreach ($name in $coreSkills) {
  $dest = Join-Path $DestDir $name
  if (-not (Test-Path $dest)) {
    continue
  }
  if (-not $BackupDir) {
    $BackupDir = Join-Path (Split-Path $DestDir -Parent) ("skills.bak-" + $timestamp)
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
  }
  Move-Item $dest $BackupDir
  $removed++
}

Write-Output "Removed $removed skill(s)."
if ($BackupDir) {
  Write-Output "Backup dir: $BackupDir"
}
