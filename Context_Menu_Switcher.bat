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
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1

if errorlevel 1 goto error
echo.
echo The old classic context menu was restored successfully.
goto finish

:modern
cls
echo Restoring the current Windows 11 context menu...

reg.exe query "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" >nul 2>&1
if errorlevel 1 (
    echo.
    echo The current Windows 11 context menu is already active.
    goto finish
)

reg.exe delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1

if errorlevel 1 goto error
echo.
echo The current Windows 11 context menu was restored successfully.
goto finish

:error
echo.
echo The operation could not be completed.
echo Try running this file as administrator.
echo.
pause
exit /b 1

:finish
echo.
echo Restart File Explorer or restart the computer
echo to apply the change.
echo.
pause
exit /b 0
