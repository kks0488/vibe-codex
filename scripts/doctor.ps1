$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsRepoRoot = Resolve-Path (Join-Path $ScriptDir "..")

$UserRoot = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
$UserSkillsDir = Join-Path $UserRoot "skills"

$Cwd = $PWD.Path
$CwdSkillsDir = Join-Path $Cwd ".codex\skills"
$RepoRoot = $null
$RepoSkillsDir = $null

if (Get-Command git -ErrorAction SilentlyContinue) {
  $inRepo = git -C $Cwd rev-parse --is-inside-work-tree 2>$null
  if ($LASTEXITCODE -eq 0) {
    $RepoRoot = (git -C $Cwd rev-parse --show-toplevel 2>$null).Trim()
    if ($RepoRoot) {
      $RepoSkillsDir = Join-Path $RepoRoot ".codex\skills"
    }
  }
}

Write-Output "VC Skills Doctor"
Write-Output "CODEX_HOME: $UserRoot"

function Get-SkillCount([string]$dir) {
  return (Get-ChildItem $dir -Directory -ErrorAction SilentlyContinue | Measure-Object).Count
}

function Test-Skill([string]$skillDir) {
  $skillFile = Join-Path $skillDir "SKILL.md"
  if (-not (Test-Path $skillFile)) {
    Write-Output "WARN: missing SKILL.md: $skillDir"
    return $false
  }

  $lines = Get-Content $skillFile
  if (-not $lines -or $lines.Count -eq 0) {
    Write-Output "WARN: empty SKILL.md: $skillFile"
    return $false
  }

  if ($lines[0].Trim() -ne "---") {
    Write-Output "WARN: missing frontmatter: $skillFile"
    return $false
  }

  $endIndex = $null
  for ($i = 1; $i -lt $lines.Count; $i++) {
    if ($lines[$i].Trim() -eq "---") {
      $endIndex = $i
      break
    }
  }
  if ($endIndex -eq $null) {
    Write-Output "WARN: unterminated frontmatter: $skillFile"
    return $false
  }

  $frontmatter = @()
  if ($endIndex -gt 1) {
    $frontmatter = $lines[1..($endIndex - 1)]
  }

  $nameLine = $frontmatter | Where-Object { $_ -match '^\s*name\s*:' } | Select-Object -First 1
  $descLine = $frontmatter | Where-Object { $_ -match '^\s*description\s*:' } | Select-Object -First 1

  $name = if ($nameLine) { ($nameLine -replace '^\s*name\s*:\s*', '').Trim() } else { "" }
  $desc = if ($descLine) { ($descLine -replace '^\s*description\s*:\s*', '').Trim() } else { "" }

  if (-not $name) {
    Write-Output "WARN: missing name: $skillFile"
    return $false
  }
  if (-not $desc) {
    Write-Output "WARN: missing description: $skillFile"
    return $false
  }

  if ($name.Length -gt 100) {
    Write-Output "WARN: name too long ($($name.Length) > 100): $skillFile"
    return $false
  }
  if ($desc.Length -gt 500) {
    Write-Output "WARN: description too long ($($desc.Length) > 500): $skillFile"
    return $false
  }

  return $true
}

function Test-SkillsDir([string]$dir, [string]$label) {
  if (-not (Test-Path $dir)) {
    return
  }

  Write-Output "Checking skill metadata ($label): $dir"
  $issues = 0
  Get-ChildItem $dir -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    if (-not (Test-Skill $_.FullName)) {
      $issues++
    }
  }

  if ($issues -eq 0) {
    Write-Output "Skill metadata OK ($label)"
  } else {
    Write-Output "Skill metadata issues: $issues ($label)"
  }
}

if (Test-Path $UserSkillsDir) {
  $count = Get-SkillCount $UserSkillsDir
  Write-Output "Skills dir (user): $UserSkillsDir ($count installed)"
} else {
  Write-Output "Skills dir not found: $UserSkillsDir"
}

if (Test-Path $CwdSkillsDir) {
  $count = Get-SkillCount $CwdSkillsDir
  Write-Output "Skills dir (repo cwd): $CwdSkillsDir ($count installed)"
}

if ($RepoSkillsDir -and ($RepoSkillsDir -ne $CwdSkillsDir) -and (Test-Path $RepoSkillsDir)) {
  $count = Get-SkillCount $RepoSkillsDir
  Write-Output "Skills dir (repo root): $RepoSkillsDir ($count installed)"
}

if (Test-Path (Join-Path $SkillsRepoRoot ".git")) {
  Write-Output "Repo: $SkillsRepoRoot"
  $branch = git -C $SkillsRepoRoot rev-parse --abbrev-ref HEAD
  $commit = git -C $SkillsRepoRoot rev-parse --short HEAD
  Write-Output "Branch: $branch"
  Write-Output "Commit: $commit"
  $versionFile = Join-Path $SkillsRepoRoot "VERSION"
  if (Test-Path $versionFile) {
    $version = (Get-Content $versionFile -Raw).Trim()
    if ($version) {
      Write-Output "Version: $version"
    }
  }
} else {
  $RepoDir = if ($env:VC_SKILLS_HOME) { $env:VC_SKILLS_HOME } elseif ($env:VS_SKILLS_HOME) { $env:VS_SKILLS_HOME } elseif ($env:VIBE_SKILLS_HOME) { $env:VIBE_SKILLS_HOME } else { Join-Path $HOME ".vc-skills" }
  Write-Output "Repo not found at: $RepoDir"
  Write-Output "Tip: set VC_SKILLS_HOME (or legacy VS_SKILLS_HOME/VIBE_SKILLS_HOME) or run the bootstrap one-liner."
}

$coreSkill = $null
if (Test-Path (Join-Path $UserSkillsDir "vc-router")) {
  $coreSkill = $UserSkillsDir
} elseif (Test-Path (Join-Path $CwdSkillsDir "vc-router")) {
  $coreSkill = $CwdSkillsDir
} elseif ($RepoSkillsDir -and (Test-Path (Join-Path $RepoSkillsDir "vc-router"))) {
  $coreSkill = $RepoSkillsDir
}

if ($coreSkill) {
  Write-Output "Core skill present: vc-router ($coreSkill)"
} else {
  Write-Output "Core skill missing: vc-router"
}

Test-SkillsDir $UserSkillsDir "user"
Test-SkillsDir $CwdSkillsDir "repo-cwd"
if ($RepoSkillsDir -and ($RepoSkillsDir -ne $CwdSkillsDir)) {
  Test-SkillsDir $RepoSkillsDir "repo-root"
}

Write-Output "Next: copy/paste into Codex chat:"
$legacySkills = Get-ChildItem $UserSkillsDir -Directory -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -like "vibe-*" -or $_.Name -like "vs-*" -or $_.Name -in @("vf", "vg", "vsf", "vsg") } |
  Select-Object -ExpandProperty Name
if ($legacySkills) {
  $legacyList = $legacySkills -join ", "
  Write-Output "Warning: legacy vibe/vs skills detected: $legacyList"
  Write-Output "Tip: remove or rename legacy skills to avoid conflicts."
}
Write-Output "use vcg: build a login page"
Write-Output "Tip: use \"use vcf: ...\" for end-to-end (plan/execute/test)."
