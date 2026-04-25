@echo off
chcp 65001 >nul
set "GIT=%USERPROFILE%\.mingit-portable\cmd\git.exe"
set "ROOT=%~dp0.."
cd /d "%ROOT%"

if not exist "%GIT%" set "GIT=git"

echo [1/2] Pushing main...
"%GIT%" push origin main
if errorlevel 1 goto :err

echo [2/2] Pushing tag v1.0.0...
"%GIT%" push origin v1.0.0
if errorlevel 1 goto :err

echo Done. Check: https://github.com/xure123-liu/ios_digitalcompass
pause
exit /b 0

:err
echo Push failed. Check network / VPN, or log in to GitHub (HTTPS credential / token).
pause
exit /b 1
