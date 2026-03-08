# Dotfiles bootstrap script for Windows.
# Installs packages via winget (preferred) with choco fallback for fonts.
#Requires -RunAsAdministrator
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── Package lists ─────────────────────────────────────────────────────

# winget packages: Id as used by `winget install`
$WingetPackages = @(
    "Git.Git"
    "Neovim.Neovim"
    "Starship.Starship"
    "sharkdp.bat"
    "BurntSushi.ripgrep"
    "sharkdp.fd"
    "dandavison.delta"
    "eza-community.eza"
    "junegunn.fzf"
    "ajeetdsouza.zoxide"
    "atuinsh.atuin"
    "Schniz.fnm"
    "GoLang.Go"
)

# Nerd Fonts — only available via choco
$ChocoFonts = @(
    "nerd-fonts-hack"
    "nerd-fonts-fira-code"
    "nerd-fonts-jetbrains-mono"
    "nerd-fonts-iosevka"
)

# ── Helpers ───────────────────────────────────────────────────────────

function Test-Command {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Install-Winget {
    if (Test-Command "winget") { return }
    Write-Host "winget not found. Please install App Installer from the Microsoft Store."
    Write-Host "https://aka.ms/getwinget"
    exit 1
}

function Install-Chocolatey {
    if (Test-Command "choco") { return }
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol =
        [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression (
        (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')
    )
}

function Install-WingetPackage {
    param([string]$Id)
    $installed = winget list --id $Id --accept-source-agreements 2>$null
    if ($LASTEXITCODE -eq 0 -and $installed -match $Id) {
        Write-Host "  [OK] $Id already installed"
        return
    }
    Write-Host "  Installing $Id..."
    winget install --id $Id --accept-package-agreements --accept-source-agreements --silent
}

function Install-ChocoPackage {
    param([string]$Name)
    $installed = choco list --local-only 2>$null | Select-String -Pattern "^$Name "
    if ($installed) {
        Write-Host "  [OK] $Name already installed"
        return
    }
    Write-Host "  Installing $Name..."
    choco install $Name -y
}

# ── Main ──────────────────────────────────────────────────────────────

function Install-Packages {
    Write-Host "`n=== Installing packages via winget ==="
    Install-Winget
    foreach ($pkg in $WingetPackages) {
        Install-WingetPackage -Id $pkg
    }

    Write-Host "`n=== Installing Nerd Fonts via Chocolatey ==="
    Install-Chocolatey
    foreach ($font in $ChocoFonts) {
        Install-ChocoPackage -Name $font
    }
}

function Set-DefaultEditor {
    # Set EDITOR/VISUAL to nvim for git and other tools
    $nvimPath = (Get-Command nvim -ErrorAction SilentlyContinue)?.Source
    if ($nvimPath) {
        [System.Environment]::SetEnvironmentVariable("EDITOR", $nvimPath, "User")
        [System.Environment]::SetEnvironmentVariable("VISUAL", $nvimPath, "User")
        Write-Host "EDITOR/VISUAL set to $nvimPath"
    }
}

function Install-NodeLTS {
    # Refresh PATH so fnm is available
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path", "User")

    if (-not (Test-Command "fnm")) {
        Write-Host "fnm not found after install — skipping Node setup"
        return
    }

    Write-Host "`n=== Setting up Node.js LTS via fnm ==="
    fnm install --lts
    fnm default lts-latest
    Write-Host "Node: $(fnm exec --using=default node -- --version)"
}

function Install-Pi {
    if (Test-Command "pi") {
        Write-Host "  [OK] pi-coding-agent already installed"
        return
    }

    # Refresh PATH so fnm/node/npm are available
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path", "User")

    if (-not (Test-Command "npm")) {
        Write-Host "npm not found — skipping pi install"
        return
    }

    Write-Host "Installing pi-coding-agent..."
    npm install -g @mariozechner/pi-coding-agent
}

function Install-Chezmoi {
    if (-not (Test-Command "chezmoi")) {
        Write-Host "`nInstalling chezmoi..."
        winget install --id twpayne.chezmoi --accept-package-agreements --accept-source-agreements --silent
        # Refresh PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                    [System.Environment]::GetEnvironmentVariable("Path", "User")
    }

    $scriptDir = Split-Path -Parent $MyInvocation.ScriptName
    Write-Host "Running 'chezmoi init --apply --source=$scriptDir'"
    chezmoi init --apply --source="$scriptDir"
}

# ── Run ───────────────────────────────────────────────────────────────

Install-Packages
Install-NodeLTS
Install-Pi
Set-DefaultEditor
Install-Chezmoi

Write-Host "`nInstallation complete!"
