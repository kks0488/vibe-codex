param(
  [string]$Command = "help",
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$Args
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..")

switch ($Command.ToLower()) {
  "install" { & (Join-Path $RepoRoot "scripts/install-skills.ps1") @Args }
  "update" { & (Join-Path $RepoRoot "scripts/update-skills.ps1") @Args }
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
      Write-Error ("Usage: vc " + $Command.ToLower() + " <goal>")
      Write-Error ("Example: vc " + $Command.ToLower() + " build a login page")
      Write-Error "Tip: include a goal so Codex doesn't have to ask for one."
      exit 1
    }
    $goal = $Args -join " "
    Write-Error "Copy/paste into Codex chat:"
    $prefix = if ($Command.ToLower() -eq "go") { "use vcg: " } else { "use vcf: " }
    Write-Output ($prefix + $goal)
  }
  "sync" {
    if (-not $Args -or $Args.Length -eq 0) {
      Write-Error "Usage: vc sync <host> [host...]"
      exit 1
    }
    & (Join-Path $RepoRoot "scripts/update-skills.ps1")
    foreach ($host in $Args) {
      Write-Output "Updating $host"
      ssh $host "curl -fsSL https://raw.githubusercontent.com/kks0488/vibe-codex/main/bootstrap.sh | bash"
    }
  }
  default {
    @"
vc commands:
  install    install skills (use --repo for .codex/skills)
  update     pull repo + reinstall skills (supports --repo)
  doctor     check install status
  list       list installed skills
  scope      manage .vc-scope (create/add/show)
  uninstall  remove skills (backup)
  prompts    print author/reviewer prompts
  go         router mode (prints "use vcg: ...")
  finish     end-to-end mode (prints "use vcf: ...")
  sync       update local + remote host(s)
"@ | Write-Output
  }
}
