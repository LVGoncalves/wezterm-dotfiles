$ErrorActionPreference = 'Stop'

if (-not (Get-Command wezterm -ErrorAction SilentlyContinue)) {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id wez.wezterm --exact --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -ne 0) { throw "winget failed with exit code $LASTEXITCODE" }
    } else {
        $release = Invoke-RestMethod 'https://api.github.com/repos/wezterm/wezterm/releases/latest'
        $asset = $release.assets | Where-Object name -Like 'WezTerm-*-setup.exe' | Select-Object -First 1
        if (-not $asset) { throw 'The current WezTerm release has no Windows installer.' }

        $installer = Join-Path ([IO.Path]::GetTempPath()) $asset.name
        try {
            Invoke-WebRequest $asset.browser_download_url -OutFile $installer -UseBasicParsing
            $process = Start-Process $installer -ArgumentList '/VERYSILENT', '/NORESTART' -Wait -PassThru
            if ($process.ExitCode -ne 0) { throw "WezTerm installer failed with exit code $($process.ExitCode)" }
        } finally {
            Remove-Item -LiteralPath $installer -Force -ErrorAction SilentlyContinue
        }
    }
}

$source = Join-Path $PSScriptRoot 'wezterm.lua'
$configDirectory = Join-Path ([Environment]::GetFolderPath('UserProfile')) '.config\wezterm'
$destination = Join-Path $configDirectory 'wezterm.lua'

New-Item -ItemType Directory -Force -Path $configDirectory | Out-Null

if (Test-Path -LiteralPath $destination) {
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss-fff'
    Copy-Item -LiteralPath $destination -Destination "$destination.backup-$stamp"
}

Copy-Item -LiteralPath $source -Destination $destination -Force
Write-Host "WezTerm is ready with config at $destination"
