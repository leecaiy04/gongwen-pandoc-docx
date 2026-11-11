[CmdletBinding()]
param(
  [string]$Proxy
)

if ($Proxy) {
  $env:HTTPS_PROXY = $Proxy
  $env:HTTP_PROXY = $Proxy
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  if (Get-Command winget -ErrorAction SilentlyContinue) {
    winget install --id GitHub.cli --exact --source winget
  } else {
    throw 'GitHub CLI is required. Install it from https://cli.github.com/ and run this command again.'
  }
}

gh auth login --hostname github.com --git-protocol https --web
gh auth setup-git
gh auth status
