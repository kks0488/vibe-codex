$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..")

$DestRoot = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
$SkillsDir = Join-Path $DestRoot "skills"

Write-Output "VS Skills Doctor"
Write-Output "CODEX_HOME: $DestRoot"

if (Test-Path $SkillsDir) {
  $count = (Get-ChildItem $SkillsDir -Directory | Measure-Object).Count
  Write-Output "Skills dir: $SkillsDir ($count installed)"
} else {
  Write-Output "Skills dir not found: $SkillsDir"
}

if (Test-Path (Join-Path $RepoRoot ".git")) {
  Write-Output "Repo: $RepoRoot"
  $branch = git -C $RepoRoot rev-parse --abbrev-ref HEAD
  $commit = git -C $RepoRoot rev-parse --short HEAD
  Write-Output "Branch: $branch"
  Write-Output "Commit: $commit"
  $versionFile = Join-Path $RepoRoot "VERSION"
  if (Test-Path $versionFile) {
    $version = (Get-Content $versionFile -Raw).Trim()
    if ($version) {
      Write-Output "Version: $version"
    }
  }
} else {
  $RepoDir = if ($env:VS_SKILLS_HOME) { $env:VS_SKILLS_HOME } elseif ($env:VIBE_SKILLS_HOME) { $env:VIBE_SKILLS_HOME } else { Join-Path $HOME ".vs-skills" }
  Write-Output "Repo not found at: $RepoDir"
  Write-Output "Tip: set VS_SKILLS_HOME (or legacy VIBE_SKILLS_HOME) or run the bootstrap one-liner."
}

if (Test-Path (Join-Path $SkillsDir "vs-router")) {
  Write-Output "Core skill present: vs-router"
} else {
  Write-Output "Core skill missing: vs-router"
}

Write-Output "Next: copy/paste into Codex chat:"
$legacySkills = Get-ChildItem $SkillsDir -Directory -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -like "vibe-*" -or $_.Name -in @("vf", "vg") } |
  Select-Object -ExpandProperty Name
if ($legacySkills) {
  $legacyList = $legacySkills -join ", "
  Write-Output "Warning: legacy vibe skills detected: $legacyList"
  Write-Output "Tip: remove or rename legacy skills to avoid conflicts."
}
Write-Output "use vsg: build a login page"
Write-Output "Tip: use ""use vsf: ..."" for end-to-end (plan/execute/test)."
