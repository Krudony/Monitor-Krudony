@echo off
echo Stopping Language Monitor...
powershell -Command "Get-WmiObject Win32_Process -Filter \"Name='powershell.exe'\" | Where-Object {$_.CommandLine -like '*LanguageMonitor.ps1*'} | ForEach-Object {Stop-Process -Id $_.ProcessId -Force}"
echo Done.
timeout /t 2
