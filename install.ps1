# Installs WezTerm, JetBrainsMono Nerd Font and this repo's wezterm.lua.
# From a clone:  powershell -ExecutionPolicy Bypass -File .\install.ps1
# From GitHub:   irm https://raw.githubusercontent.com/LVGoncalves/wezterm-dotfiles/main/install.ps1 | iex

& {
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'  # Invoke-WebRequest is very slow with the progress bar
$repo = 'https://raw.githubusercontent.com/LVGoncalves/wezterm-dotfiles/main'

# --- WezTerm ---------------------------------------------------------------
if (-not (Get-Command wezterm -ErrorAction SilentlyContinue) -and -not (Test-Path "$env:ProgramFiles\WezTerm\wezterm.exe")) {
    Write-Host 'Installing WezTerm...'
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

# --- Font (per-user, no admin needed) --------------------------------------
$userFonts = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'
$hasFont = (Test-Path "$env:SystemRoot\Fonts\JetBrainsMonoNerdFont-Regular.ttf") -or
           (Test-Path "$userFonts\JetBrainsMonoNerdFont-Regular.ttf")
if (-not $hasFont) {
    Write-Host 'Installing JetBrainsMono Nerd Font...'
    $tmp = Join-Path ([IO.Path]::GetTempPath()) "wezterm-font-$([guid]::NewGuid())"
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        $archive = Join-Path $tmp 'JetBrainsMono.tar.xz'
        Invoke-WebRequest 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz' -OutFile $archive -UseBasicParsing
        & "$env:SystemRoot\System32\tar.exe" -xf $archive -C $tmp
        if ($LASTEXITCODE -ne 0) { throw "tar failed with exit code $LASTEXITCODE" }

        New-Item -ItemType Directory -Force -Path $userFonts | Out-Null
        $registry = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'
        foreach ($font in Get-ChildItem $tmp -Filter 'JetBrainsMonoNerdFont-*.ttf') {
            $target = Join-Path $userFonts $font.Name
            Copy-Item -LiteralPath $font.FullName -Destination $target -Force
            New-ItemProperty -Path $registry -Name "$($font.BaseName) (TrueType)" -Value $target -PropertyType String -Force | Out-Null
        }
    } finally {
        Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# --- Config ----------------------------------------------------------------
$configHome = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { Join-Path $env:USERPROFILE '.config' }
$configDirectory = Join-Path $configHome 'wezterm'
$destination = Join-Path $configDirectory 'wezterm.lua'
New-Item -ItemType Directory -Force -Path $configDirectory | Out-Null

$new = Join-Path ([IO.Path]::GetTempPath()) "wezterm-$([guid]::NewGuid()).lua"
$local = if ($PSScriptRoot) { Join-Path $PSScriptRoot 'wezterm.lua' }
if ($local -and (Test-Path -LiteralPath $local)) {
    Copy-Item -LiteralPath $local -Destination $new
} else {
    Invoke-WebRequest "$repo/wezterm.lua" -OutFile $new -UseBasicParsing
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
if ((Test-Path -LiteralPath $destination) -and
    (Get-FileHash -LiteralPath $destination).Hash -ne (Get-FileHash -LiteralPath $new).Hash) {
    Copy-Item -LiteralPath $destination -Destination "$destination.backup-$stamp"
}
Move-Item -LiteralPath $new -Destination $destination -Force

# A leftover ~/.wezterm.lua is ignored by WezTerm and only causes confusion.
$legacy = Join-Path $env:USERPROFILE '.wezterm.lua'
if (Test-Path -LiteralPath $legacy) {
    Move-Item -LiteralPath $legacy -Destination "$legacy.backup-$stamp"
    Write-Host "Moved old $legacy to $legacy.backup-$stamp"
}

Write-Host "WezTerm is ready with config at $destination. Restart WezTerm to pick up new fonts."
}
