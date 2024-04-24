# src: https://gist.github.com/apfelchips/792f7708d0adff7785004e9855794bc0
# https://gist.github.com/apfelchips/792f7708d0adff7785004e9855794bc0#file-choco_install-ps1
# goal: install all basic tools / pin software with working autoupdate mechanism / specialized stuff is commented out
##################################################
# Ejecutar PS como administrador y luego:
# Set-ExecutionPolicy Bypass -Scope Process
##################################################

# Check Permissions
if ( -Not( (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) ){
    Write-Error -Message "Script needs Administrator permissions"
    exit 1
}

if (-Not (Get-Command "choco" -errorAction SilentlyContinue)) {
   [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
   iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

choco feature enable -n=allowGlobalConfirmation

## https://chocolatey.org/packages

choco install 7zip
choco install anydesk
choco install chocolateygui
choco install firefox
choco install inkscape
choco install mpv 
choco install visualstudiocode
choco install vlc

## Sysinternals
choco install autoruns

## HARDWARE MONITORING
choco install cpu-z
choco install gpu-z
choco install pci-z