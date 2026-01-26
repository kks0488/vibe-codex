$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..")
$SrcDir = Join-Path $RepoRoot "skills"
$CoreSkillsFile = Join-Path $ScriptDir "core-skills.txt"

function Show-Usage {
@"
Usage: install-skills.ps1 [--core|--all] [--user|--repo|--path <dir>]

  --core        Install vibe-codex core skills only (default)
  --all         Install all bundled skills
  --user        Install to `$CODEX_HOME\\skills (default)
  --repo        Install to <git-root>\\.codex\\skills (from current directory)
  --path <dir>  Install to an explicit skills directory
"@ | Write-Output
}

function Get-CoreSkills {
  if (-not (Test-Path $CoreSkillsFile)) {
    Write-Error "Error: missing core skills list: $CoreSkillsFile"
    exit 1
  }
  return Get-Content $CoreSkillsFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not $_.StartsWith("#") }
}

$Scope = "user"
$Mode = "core"
$CustomDest = $null
for ($i = 0; $i -lt $Args.Length; $i++) {
  switch ($Args[$i]) {
    "--core" { $Mode = "core" }
    "--all" { $Mode = "all" }
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

New-Item -ItemType Directory -Force -Path $DestDir | Out-Null

$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$backupDir = $null
if ($Mode -eq "all") {
  Get-ChildItem $SrcDir -Directory | ForEach-Object {
    $dest = Join-Path $DestDir $_.Name
    if (Test-Path $dest) {
      if (-not $backupDir) {
        $backupDir = Join-Path $DestDir (".bak-" + $timestamp)
        New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
      }
      Move-Item $dest $backupDir
    }
    Copy-Item $_.FullName $dest -Recurse -Force
  }
} else {
  $coreSkills = Get-CoreSkills
  foreach ($name in $coreSkills) {
    $skillDir = Join-Path $SrcDir $name
    if (-not (Test-Path $skillDir)) {
      Write-Warning "Core skill missing in repo (skipping): $name"
      continue
    }
    $dest = Join-Path $DestDir $name
    if (Test-Path $dest) {
      if (-not $backupDir) {
        $backupDir = Join-Path $DestDir (".bak-" + $timestamp)
        New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
      }
      Move-Item $dest $backupDir
    }
    Copy-Item $skillDir $dest -Recurse -Force
  }
}

Write-Output "Installed skills to $DestDir"
Write-Output "Mode: $Mode"
if ($backupDir) {
  Write-Output "Backup dir: $backupDir"
}
Write-Output "Next: copy/paste into Codex chat:"
$legacySkills = Get-ChildItem $DestDir -Directory -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -like "vibe-*" -or $_.Name -like "vs-*" -or $_.Name -in @("vf", "vg", "vsf", "vsg") } |
  Select-Object -ExpandProperty Name
if ($legacySkills) {
  $legacyList = $legacySkills -join ", "
  Write-Output "Warning: legacy vibe/vs skills detected: $legacyList"
  Write-Output "Tip: remove or rename legacy skills to avoid conflicts."
}
Write-Output "use vcg: build a login page"
Write-Output "Tip: use ""use vcf: ..."" for end-to-end (plan/execute/test)."
