param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$Paths
)

$ScopeFile = Join-Path (Get-Location) ".vs-scope"

function Get-RemainingArgs {
  param([string[]]$Args)
  if (-not $Args -or $Args.Length -le 1) { return @() }
  return $Args[1..($Args.Length - 1)]
}

function Write-Header {
  param([string]$Path)
  @(
    "# VS scope roots"
    "# One path per line (relative to this file unless absolute)"
  ) | Set-Content -Path $Path -Encoding utf8
}

$cmd = "init"
if ($Paths -and $Paths.Length -gt 0) {
  $cmd = $Paths[0].ToLower()
}

switch ($cmd) {
  "add" {
    $rest = Get-RemainingArgs $Paths
    if (-not $rest -or $rest.Length -eq 0) {
      Write-Error "Usage: vs scope add <path> [path...]"
      exit 1
    }
    if (-not (Test-Path $ScopeFile)) {
      Write-Header $ScopeFile
    }
    $existing = @()
    if (Test-Path $ScopeFile) {
      $existing = Get-Content $ScopeFile
    }
    foreach ($p in $rest) {
      if ($p -and ($existing -notcontains $p)) {
        Add-Content -Path $ScopeFile -Value $p -Encoding utf8
      }
    }
    Write-Output "Updated $ScopeFile"
  }
  "show" {
    if (-not (Test-Path $ScopeFile)) {
      Write-Error "Not found: $ScopeFile"
      exit 1
    }
    Get-Content $ScopeFile
  }
  "init" {
    $rest = Get-RemainingArgs $Paths
    if (Test-Path $ScopeFile) {
      Write-Output "Already exists: $ScopeFile"
      exit 0
    }
    if (-not $rest -or $rest.Length -eq 0) {
      $rest = @(".")
    }
    Write-Header $ScopeFile
    foreach ($p in $rest) {
      if ($p) {
        Add-Content -Path $ScopeFile -Value $p -Encoding utf8
      }
    }
    Write-Output "Created $ScopeFile"
  }
  default {
    if (Test-Path $ScopeFile) {
      Write-Output "Already exists: $ScopeFile"
      exit 0
    }
    if (-not $Paths -or $Paths.Length -eq 0) {
      $Paths = @(".")
    }
    Write-Header $ScopeFile
    foreach ($p in $Paths) {
      if ($p) {
        Add-Content -Path $ScopeFile -Value $p -Encoding utf8
      }
    }
    Write-Output "Created $ScopeFile"
  }
}
