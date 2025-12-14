@echo off
setlocal
echo ==========================================
echo    Language Monitor - Build Script
echo ==========================================
echo.

REM Check for .NET SDK
dotnet --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] .NET SDK is not installed or not in PATH.
    echo Please install .NET 8 SDK from https://dotnet.microsoft.com/download
    echo.
    pause
    exit /b 1
)

echo Building Self-Contained Single File executable...
echo This may take a minute...
echo.

REM Build command
dotnet publish src/LanguageMonitor/LanguageMonitor.csproj -c Release -r win-x64 -p:PublishSingleFile=true --self-contained true -o build_output

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Build failed! Please check the error messages above.
    pause
    exit /b 1
)

echo.
echo Copying executable to project root...
copy /Y "build_output\LanguageMonitor.exe" "LanguageMonitor.exe" >nul

REM Cleanup build output folder
rd /s /q build_output

if exist LanguageMonitor.exe (
    echo.
    echo [SUCCESS] Build complete!
    echo Filename: LanguageMonitor.exe
    echo You can now run 'Install.bat' or use the program directly.
) else (
    echo.
    echo [ERROR] File copy failed.
)

echo.
pause
