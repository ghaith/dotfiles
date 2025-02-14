
# Function to check if a package is installed using Chocolatey
function Is-PackageInstalled {
    param (
        [string]$packageName
    )
    choco list --local-only | Select-String -Pattern $packageName
}

# Function to install Chocolatey if not installed
function Install-Chocolatey {
    if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    } else {
        Write-Host "Chocolatey is already installed."
    }
}

# Function to install packages using Chocolatey
function Install-Packages {
    choco install git curl neovim starship nerd-fonts-hack nerd-fonts-fira-code nerd-fonts-jetbrains-mono nerd-fonts-iosevka -y
    #$packages = @("git", "vim", "curl")
    #
    #foreach ($pkg in $packages) {
    #    if (-Not (Is-PackageInstalled $pkg)) {
    #        Write-Host "Installing $pkg..."
    #        choco install $pkg -y
    #    } else {
    #        Write-Host "$pkg is already installed."
    #    }
    #}
}

# Main script execution
Install-Chocolatey
Install-Packages

Write-Host "Installation complete!"
