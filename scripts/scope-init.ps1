param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$Paths
)

$ScopeFile = Join-Path (Get-Location) ".vibe-scope"

if (Test-Path $ScopeFile) {
  Write-Output "Already exists: $ScopeFile"
  exit 0
}

if (-not $Paths -or $Paths.Length -eq 0) {
  $Paths = @(".")
}

$Content = @(
  "# Vibe scope roots"
  "# One path per line (relative to this file unless absolute)"
) + $Paths

Set-Content -Path $ScopeFile -Value $Content -Encoding utf8
Write-Output "Created $ScopeFile"
