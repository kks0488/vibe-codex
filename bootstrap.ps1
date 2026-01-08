$RepoUrl = "https://github.com/kks0488/vibe-skills.git"
$Dest = if ($env:VIBE_SKILLS_HOME) { $env:VIBE_SKILLS_HOME } else { Join-Path $HOME ".vibe-skills" }

if (Get-Command git -ErrorAction SilentlyContinue) {
  if (Test-Path (Join-Path $Dest ".git")) {
    git -C $Dest pull --ff-only
  } else {
    git clone $RepoUrl $Dest
  }
} else {
  Write-Error "git is required. Install git first and re-run."
  exit 1
}

& (Join-Path $Dest "scripts/install-skills.ps1")
