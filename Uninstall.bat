@echo off
echo ==========================================
echo   Language Monitor - Uninstall Auto-Start
echo ==========================================
echo.

set STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup

if exist "%STARTUP%\LanguageMonitor.lnk" (
    del "%STARTUP%\LanguageMonitor.lnk"
    echo [OK] Auto-start removed!
) else (
    echo [INFO] Auto-start was not installed.
)
echo.
pause
