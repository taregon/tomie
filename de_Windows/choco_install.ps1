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

# ======================================
# APLICACIONES
# ======================================
choco install
choco install 7zip
choco install aimp
choco install anydesk
choco install audacity
choco install chocolateygui
choco install conemu
choco install dropbox
choco install f.lux
choco install foxitreader
choco install inkscape
choco install lightscreen
choco install mp3tag
choco install mpv
choco install rawtherapee
choco install syncplay
choco install telegram
choco install upscayl
choco install vlc
choco install vscode

# ======================================
# NAVEGADORES
# ======================================
choco install brave
choco install firefox --params "/l:es-MX"

# ======================================
# SYSINTERNALS
# ======================================
choco install advanced-ip-scanner
choco install autoruns
choco install dupeguru
choco install fastcopy
choco install HashCheck     # Pestaña en propiedades de archivo
choco install lockhunter
choco install mremoteng
choco install onecommander
choco install putty
choco install spek
# ======================================
# COMANDOS
# ======================================
choco install adb
choco install bind-toolsonly
choco install cmder
choco install git
choco install nmap
choco install yt-dlp

# ======================================
# HARDWARE MONITORING
# ======================================
choco install bulk-crap-uninstaller
choco install cpu-z
choco install crystaldiskinfo
choco install dupeguru
choco install librkehardwaremonitor
choco install treesizefree
choco install usbdeview
