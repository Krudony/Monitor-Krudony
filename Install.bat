@echo off
echo ==========================================
echo    Language Monitor - Install Auto-Start
echo ==========================================
echo.

set STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
set SCRIPT=%~dp0Start.vbs

echo Creating shortcut in Startup folder...

echo Set oWS = WScript.CreateObject("WScript.Shell") > "%TEMP%\create_shortcut.vbs"
echo sLinkFile = "%STARTUP%\LanguageMonitor.lnk" >> "%TEMP%\create_shortcut.vbs"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%TEMP%\create_shortcut.vbs"
echo oLink.TargetPath = "%SCRIPT%" >> "%TEMP%\create_shortcut.vbs"
echo oLink.WorkingDirectory = "%~dp0" >> "%TEMP%\create_shortcut.vbs"
echo oLink.Save >> "%TEMP%\create_shortcut.vbs"

cscript //nologo "%TEMP%\create_shortcut.vbs"
del "%TEMP%\create_shortcut.vbs"

echo.
echo [OK] Auto-start installed!
echo Language Monitor will start automatically when Windows boots.
echo.
pause
