@echo off
REM Comprime cada directorio, en el directorio actual, en un archivo .7z sin contraseña.
REM Utiliza 7-Zip para realizar la compresión con el nivel (9) máximo de compresión.

for /d %%X in (*) do "%systemdrive%\Program Files\7-Zip\7z.exe" a -mx9 "%%X.7z" "%%X\"
pause
