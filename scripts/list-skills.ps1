$DestRoot = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
$SkillsDir = Join-Path $DestRoot "skills"

if (-not (Test-Path $SkillsDir)) {
  Write-Error "Skills dir not found: $SkillsDir"
  exit 1
}

Get-ChildItem $SkillsDir -Directory -ErrorAction SilentlyContinue |
  Where-Object { -not $_.Name.StartsWith(".") -and (Test-Path (Join-Path $_.FullName "SKILL.md")) } |
  Select-Object -ExpandProperty Name |
  Sort-Object
