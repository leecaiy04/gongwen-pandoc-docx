[CmdletBinding()]
param(
  [ValidateSet('codex', 'workbuddy')]
  [Parameter(Mandatory = $true)]
  [string]$Target,
  [switch]$Force,
  [switch]$Link
)

$SkillDir = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$SkillName = 'gongwen-pandoc-docx'
$Roots = @{
  'codex' = $(if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME 'skills' } else { Join-Path $HOME '.codex\skills' })
  'workbuddy' = Join-Path $HOME '.workbuddy\skills'
}
$Destination = Join-Path $Roots[$Target] $SkillName

New-Item -ItemType Directory -Force -Path $Roots[$Target] | Out-Null
if (Test-Path $Destination) {
  if (-not $Force) { throw "Already exists: $Destination. Review it, then rerun with -Force if replacement is intended." }
  Remove-Item -Recurse -Force $Destination
}

if ($Link) {
  New-Item -ItemType SymbolicLink -Path $Destination -Target $SkillDir | Out-Null
} else {
  New-Item -ItemType Directory -Path $Destination | Out-Null
  Copy-Item -Path (Join-Path $SkillDir 'SKILL.md') -Destination $Destination
  Copy-Item -Recurse -Path (Join-Path $SkillDir 'assets'), (Join-Path $SkillDir 'scripts') -Destination $Destination
  Get-ChildItem -Path (Join-Path $Destination 'scripts') -Directory -Filter '__pycache__' -Recurse | Remove-Item -Recurse -Force
  Get-ChildItem -Path (Join-Path $Destination 'scripts') -File -Filter '*.pyc' -Recurse | Remove-Item -Force
}

if (-not (Test-Path (Join-Path $Destination 'SKILL.md'))) { throw 'Installation failed.' }
Write-Output "Installed: $Target -> $Destination"
