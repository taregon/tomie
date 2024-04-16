@echo off
for /d %%X in (*) do "%systemdrive%\Program Files\7-Zip\7z.exe" a -mx9 "%%X.7z" "%%X\"
pause
