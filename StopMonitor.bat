@echo off
echo Stopping Language Monitor...
taskkill /IM LanguageMonitor.exe /F >nul 2>&1
echo Done.
timeout /t 2
