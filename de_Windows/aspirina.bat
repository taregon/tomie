@echo off

REM 1. Ejecuta el Comprobador de archivos de sistema para verificar y reparar archivos del sistema.
sfc /scannow

REM 2. Verifica la integridad de la imagen de Windows. Solo informa sobre el estado.
DISM /Online /Cleanup-Image /CheckHealth

REM 3. Realiza un escaneo más detallado de la imagen de Windows para buscar corrupción.
DISM /Online /Cleanup-Image /ScanHealth

REM 4. Intenta reparar automáticamente cualquier corrupción encontrada en la imagen de Windows.
DISM /Online /Cleanup-Image /RestoreHealth
