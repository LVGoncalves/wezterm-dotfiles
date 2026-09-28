$ErrorActionPreference = 'Stop'

$source = Join-Path $PSScriptRoot 'wezterm.lua'
$configDirectory = Join-Path ([Environment]::GetFolderPath('UserProfile')) '.config\wezterm'
$destination = Join-Path $configDirectory 'wezterm.lua'

New-Item -ItemType Directory -Force -Path $configDirectory | Out-Null

if (Test-Path -LiteralPath $destination) {
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss-fff'
    Copy-Item -LiteralPath $destination -Destination "$destination.backup-$stamp"
}

Copy-Item -LiteralPath $source -Destination $destination -Force
Write-Host "Installed WezTerm config at $destination"
