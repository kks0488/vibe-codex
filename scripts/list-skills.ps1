$Scope = "user"
$CustomDest = $null
$UseAgents = $false

function Show-Usage {
@"
Usage: list-skills.ps1 [--user|--repo|--path <dir>] [--agents]

  --user        List user scope skills (default)
                - default: `$CODEX_HOME\\skills (legacy-compatible)
                - with --agents: ~\\.agents\\skills (Codex docs default)
  --repo        List repo scope skills (from current directory)
                - default: <git-root>\\.codex\\skills
                - with --agents: <git-root>\\.agents\\skills
  --path <dir>  List skills from an explicit skills directory
  --agents      Use .agents\\skills locations for --user/--repo
"@ | Write-Output
}

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
    $SkillsDir = $CustomDest
  } else {
    $SkillsDir = Join-Path $PWD.Path $CustomDest
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
    $SkillsDir = Join-Path $repoRoot.Trim() ".agents\\skills"
  } else {
    $SkillsDir = Join-Path $repoRoot.Trim() ".codex\\skills"
  }
} else {
  if ($UseAgents) {
    $SkillsDir = Join-Path $HOME ".agents\\skills"
  } else {
    $DestRoot = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
    $SkillsDir = Join-Path $DestRoot "skills"
  }
}

if (-not (Test-Path $SkillsDir)) {
  Write-Error "Skills dir not found: $SkillsDir"
  exit 1
}

Get-ChildItem $SkillsDir -Directory -ErrorAction SilentlyContinue |
  Where-Object { -not $_.Name.StartsWith(".") -and (Test-Path (Join-Path $_.FullName "SKILL.md")) } |
  Select-Object -ExpandProperty Name |
  Sort-Object
