@echo off
setlocal
title Windows 11 Context Menu Switcher
color 0B

:menu
cls
echo ================================================
echo        Windows 11 Context Menu Switcher
echo ================================================
echo.
echo [1] Restore the old classic context menu
echo [2] Restore the current Windows 11 context menu
echo.
choice /c 12 /n /m "Choose 1 or 2: "

if errorlevel 2 goto modern
if errorlevel 1 goto classic

:classic
cls
echo Restoring the old classic context menu...
echo.
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

if errorlevel 1 goto error
echo.
echo The old classic context menu was restored successfully.
goto restart_explorer

:modern
cls
echo Restoring the current Windows 11 context menu...
echo.
reg.exe delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f

if errorlevel 1 goto error
echo.
echo The current Windows 11 context menu was restored successfully.
goto restart_explorer

:restart_explorer
echo.
echo Restarting File Explorer to apply the change...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul
start "" explorer.exe
echo.
echo File Explorer was restarted successfully.
echo.
pause
exit /b 0

:error
echo.
echo The operation could not be completed.
echo Try running this file as administrator.
echo.
pause
exit /b 1
