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
$ChocoDirLog = "$ChocoDirCache/$env:COMPUTERNAME"
$ChocoLibPath = "$env:ChocolateyInstall\lib"
$ChocoLog = "$ChocoDirLog\chocolatey_log_$(Get-Date -UFormat "%Y-%m-%d").log"

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
    "anydesk"
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
    "vscode",
    # ----------------------------------
    # NAVEGADORES
    # ----------------------------------
    "brave",
    "firefox",
    # ----------------------------------
    # SYSINTERNALS
    # ----------------------------------
    "advanced-ip-scanner",
    "autoruns",
    "dupeguru",
    "fastcopy",
    "filezilla",
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
    "exiftool",
    "git",
    "nmap",
    "whois",
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
# Fragmento obtenido de: https://gist.github.com/RafaelM1994/791cb40d8df4994dd1371bd40e346424
function Install-ChocoApps {
    param (
        [String]$ChocoApps,
        [String]$ChocoParams
    )
    if (!((test-path "$ChocoLibPath\$ChocoApps"))) {
        $StartTime = Get-Date
        Write-Host "[INFO] Instalando $ChocoApps" -ForegroundColor Black -BackgroundColor Yellow -NoNewline; Write-Host ([char]0xA0)
        choco install $ChocoApps --params $ChocoParams --nocolor --limitoutput --log-file=$ChocoLog
        Write-Host "Tiempo de ejecucion: $((Get-Date).Subtract($StartTime).Seconds) segundos" -ForegroundColor DarkGray -NoNewline; Write-Host ([char]0xA0)

    }
    else {
        Write-Host "[ OK ] $ChocoApps $ChocoParams" -ForegroundColor Green -NoNewline; Write-Host ([char]0xA0)
    }
}
foreach ($Package in $Aplicaciones) {
    switch ($Package) {
        "firefox" { $Params = "/l:es-MX" }
        # "audacity" { $Params = "--some-params" }
        default { $Params = "" }
    }
    Install-ChocoApps -ChocoApps $Package -ChocoParams $Params
}
# ======================================
# AGREGANDO TAREA PROGRAMADA
# ======================================
$ChocoUpgrade = @{
    Name               = "Chocolatey Daily Upgrade"
    ScriptBlock        = { choco upgrade all -y }
    Trigger            = New-JobTrigger -Daily -at "8:00PM"
    ScheduledJobOption = New-ScheduledJobOption -RunElevated -MultipleInstancePolicy StopExisting -RequireNetwork
}
Register-ScheduledJob @ChocoUpgrade
# ======================================
# EXTRA (LUEGO LO ELIMINO)
# ======================================
$appsToInstall = $Aplicaciones -split "," | foreach { "$($_.Trim())" }

Write-Host "$appsToInstall"