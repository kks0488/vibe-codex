$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..")
$SrcDir = Join-Path $RepoRoot "skills"
$CoreSkillsFile = Join-Path $ScriptDir "core-skills.txt"

function Show-Usage {
@"
Usage: prune-skills.ps1 [--user|--repo|--path <dir>] [--dry-run]

Removes (backs up) bundled non-core vibe-codex skills from the destination skills directory.
Only affects skills that exist in this repo's skills/ folder.

  --user        Use `$CODEX_HOME\\skills (default)
  --repo        Use <git-root>\\.codex\\skills (from current directory)
  --path <dir>  Use an explicit skills directory
  --dry-run     Print what would change, but don't move anything
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
$DryRun = $false
for ($i = 0; $i -lt $Args.Length; $i++) {
  switch ($Args[$i]) {
    "--user" { $Scope = "user" }
    "--repo" { $Scope = "repo" }
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
  $DestDir = Join-Path $repoRoot.Trim() ".codex\\skills"
} else {
  $DestRoot = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
  $DestDir = Join-Path $DestRoot "skills"
}

if (-not (Test-Path $DestDir)) {
  Write-Error "Skills dir not found: $DestDir"
  exit 1
}

$core = New-Object 'System.Collections.Generic.HashSet[string]'
Get-CoreSkills | ForEach-Object { [void]$core.Add($_) }

$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$backupDir = $null
$removed = 0

Get-ChildItem $SrcDir -Directory | ForEach-Object {
  $name = $_.Name
  if ($core.Contains($name)) {
    return
  }
  $dest = Join-Path $DestDir $name
  if (-not (Test-Path $dest)) {
    return
  }
  if ($DryRun) {
    Write-Output "Would move: $dest"
    $removed++
    return
  }
  if (-not $backupDir) {
    $backupDir = Join-Path $DestDir (".bak-" + $timestamp)
    New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
  }
  Move-Item $dest $backupDir
  $removed++
}

if ($DryRun) {
  Write-Output "Dry run complete. Would remove $removed skill(s) from $DestDir."
  exit 0
}

Write-Output "Removed $removed skill(s) from $DestDir (non-core only)."
if ($backupDir) {
  Write-Output "Backup dir: $backupDir"
}

