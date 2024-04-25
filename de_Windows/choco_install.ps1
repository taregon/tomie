<#
.SYNOPSIS
    Instala aplicaciones útiles para mi. Obvio.
.NOTES
    Primero ejecutar Powershell como administrador
    Luego, habilitar la ejecución de script
.EXAMPLE
    Set-ExecutionPolicy Bypass -Scope Process
.LINK
    Si deseas agregar programas, antes revisar en:
    https://chocolatey.org/packages
#>

# Porción obtenida de https://gist.github.com/apfelchips/792f7708d0adff7785004e9855794bc0
# Revisa si PowerSHell esta como administrador

if ( -Not( (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) ) {
    Write-Error -Message "Debes ejecutar PowerShell como Administrador"
    exit 1
}

if (-Not (Get-Command "choco" -errorAction SilentlyContinue)) {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

choco feature enable -n=allowGlobalConfirmation

# ================================
# APLICACIONES
# ================================
choco install 7zip
choco install aimp
choco install anydesk
choco install chocolateygui
choco install dropbox
choco install inkscape
choco install mpv
choco install telegram
choco install upscayl
choco install visualstudiocode
choco install vlc

# ================================
# NAVEGADORES
# ================================
choco install firefox
choco install brave

# ================================
# SYSINTERNALS
# ================================
choco install autoruns

# ================================
# HARDWARE MONITORING
# ================================
choco install cpu-z
choco install usbdeview
