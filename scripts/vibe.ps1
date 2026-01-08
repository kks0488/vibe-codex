param(
  [string]$Command = "help",
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$Args
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..")

switch ($Command.ToLower()) {
  "install" { & (Join-Path $RepoRoot "scripts/install-skills.ps1") }
  "update" { & (Join-Path $RepoRoot "scripts/update-skills.ps1") }
  "doctor" { & (Join-Path $RepoRoot "scripts/doctor.ps1") }
  "list" { & (Join-Path $RepoRoot "scripts/list-skills.ps1") }
  "scope" { & (Join-Path $RepoRoot "scripts/scope-init.ps1") @Args }
  "uninstall" { & (Join-Path $RepoRoot "scripts/uninstall-skills.ps1") }
  "prompts" {
    $promptArg = if ($Args -and $Args.Length -gt 0) { $Args[0] } else { "all" }
    & (Join-Path $RepoRoot "scripts/role-prompts.ps1") $promptArg
  }
  { $_ -in @("go", "finish") } {
    if (-not $Args -or $Args.Length -eq 0) {
      Write-Error ("Usage: vibe " + $Command.ToLower() + " <goal>")
      Write-Error ("Example: vibe " + $Command.ToLower() + " build a login page")
      Write-Error "Tip: include a goal so Codex doesn't have to ask for one."
      exit 1
    }
    $goal = $Args -join " "
    Write-Error "Copy/paste into Codex chat:"
    $prefix = if ($Command.ToLower() -eq "go") { "use vg: " } else { "use vf: " }
    Write-Output ($prefix + $goal)
  }
  "sync" {
    if (-not $Args -or $Args.Length -eq 0) {
      Write-Error "Usage: vibe sync <host> [host...]"
      exit 1
    }
    & (Join-Path $RepoRoot "scripts/update-skills.ps1")
    foreach ($host in $Args) {
      Write-Output "Updating $host"
      ssh $host "curl -fsSL https://raw.githubusercontent.com/kks0488/vibe-skills/main/bootstrap.sh | bash"
    }
  }
  default {
    @"
vibe commands:
  install    install skills into ~/.codex/skills
  update     pull repo + reinstall skills
  doctor     check install status
  list       list installed skills
  scope      manage .vibe-scope (create/add/show)
  uninstall  remove skills (backup)
  prompts    print author/reviewer prompts
  go         router mode (prints "use vg: ...")
  finish     end-to-end mode (prints "use vf: ...")
  sync       update local + remote host(s)
"@ | Write-Output
  }
}
