<#
.SYNOPSIS
    Instala aplicaciones útiles para mi. Obvio.
.NOTES
    Primero ejecutar Powershell como administrador
    Luego, habilitar la ejecución de script
    Ruta de logs: C:\ProgramData\chocolatey\logs\chocolatey.log
.EXAMPLE
    Set-ExecutionPolicy Bypass -Scope Process
.LINK
    Si deseas agregar programas, antes revisar en:
    https://chocolatey.org/packages
#>

# Fragmento obtenido de https://gist.github.com/apfelchips/792f7708d0adff7785004e9855794bc0
# Revisa si PowerSHell esta como administrador

if (-Not( (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) ) {
    Write-Error -Message "* * * Debes ejecutar PowerShell como Administrador * * *"
    exit 1
}

if (-Not (Get-Command "choco" -errorAction SilentlyContinue)) {
    Write-Host "`n Instalando Chocolatey" -ForegroundColor Black -BackgroundColor Yellow -NoNewline; Write-Host ([char]0xA0)
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# ======================================
# AJUSTES EN CHOCOLATELY
# ======================================
$ChocoDirCache = "$env:ALLUSERSPROFILE\ChocolateyAppsCache"

Write-Host "* Ruta para la descarga de Aplicaciones"
choco config set cacheLocation $ChocoDirCache
Write-Host "* Limite de ejecucion de comandos a 30 minutos"
choco config set commandExecutionTimeoutSeconds 1800
Write-Host "* Habilitando confirmacion global para instalacion de Aplicaciones"
choco feature enable -n=allowGlobalConfirmation

# ======================================
# DECORACIONES DE PANTALLA
# ======================================
$host.UI.RawUI.WindowTitle = "Instalando aplicaciones con Chocolatey"
Write-Host "`n Instalando aplicaciones " -ForegroundColor Black -BackgroundColor Yellow -NoNewline; Write-Host ([char]0xA0)

$ChocoDate = {
    Write-Host "====================" -ForegroundColor Yellow -NoNewline; Write-Host ([char]0xA0)
    Write-Host " Fecha: $(Get-Date -UFormat "%d %b %Y") " -ForegroundColor DarkYellow -NoNewline; Write-Host ([char]0xA0)
    Write-Host " Hora:  $(Get-Date -f "HH:mm:ss") " -ForegroundColor DarkYellow -NoNewline; Write-Host ([char]0xA0)
    Write-Host "====================" -ForegroundColor Yellow -NoNewline; Write-Host ([char]0xA0)
}
.$ChocoDate

# ======================================
# LISTA DE APLICACIONES
# ======================================
$Aplicaciones = @(
    # ----------------------------------
    # DE USUARIO
    # ----------------------------------
    "7zip",
    "aimp",
    "anydesk",
    "audacity",
    "chocolateygui",
    "conemu",
    "dropbox",
    "f.lux",
    "foxitreader",
    "inkscape",
    "lightscreen",
    "mp3tag",
    "mpv",
    "rawtherapee",
    "syncplay",
    "telegram",
    "upscayl",
    "vlc",
    "exiftool",
    "vscode",
    # ----------------------------------
    # SYSINTERNALS
    # ----------------------------------
    "advanced-ip-scanner",
    "autoruns",
    "dupeguru",
    "fastcopy",
    "HashCheck",
    "lockhunter",
    "mremoteng",
    "onecommander",
    "putty",
    "spek",
    # ----------------------------------
    # COMANDOS
    # ----------------------------------
    "adb",
    "bind-toolsonly",
    "cmder",
    "git",
    "nmap",
    "yt-dlp",
    # ----------------------------------
    # HARDWARE MONITORING
    # ----------------------------------
    "bulk-crap-uninstaller",
    "cpu-z",
    "crystaldiskinfo",
    "dupeguru",
    "librehardwaremonitor",
    "treesizefree",
    "usbdeview"
)

# ======================================
# INSTALANDO PROGRAMAS
# ======================================
function ChocoApps {

    [cmdletbinding()]
    param (
        [String]$Apps
    )

    $ChocoLibPath = "$env:ChocolateyInstall\lib"

    if (!((test-path "$ChocoLibPath\$Apps"))) {

        Write-Host "[INFO] Instalando $Apps" -ForegroundColor Black -BackgroundColor Yellow -NoNewline; Write-Host ([char]0xA0)
        choco install $Apps --nocolor --limitoutput
    }
    else {
        Write-Host "[OK] $Apps" -ForegroundColor Green -NoNewline; Write-Host ([char]0xA0)
    }
}

foreach ($Package in $Aplicaciones) {
    ChocoApps -Apps $Package
}