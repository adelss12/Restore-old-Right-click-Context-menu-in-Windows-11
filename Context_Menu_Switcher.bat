@echo off
setlocal EnableExtensions
title Windows 11 Context Menu Switcher v1.1.0
color 0B

rem ------------------------------------------------------------------
rem  Windows 11 Context Menu Switcher
rem  Switches between the classic (full) right-click menu and the
rem  modern Windows 11 menu. Changes only the current user's settings
rem  (HKCU), so administrator rights are NOT needed.
rem ------------------------------------------------------------------

set "KEY=HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"

rem --- Make sure this is Windows 11 (build 22000 or newer) ---
set "BUILD="
for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild 2^>nul ^| find "CurrentBuild"') do set "BUILD=%%a"
if not defined BUILD set "BUILD=0"
if %BUILD% LSS 22000 (
    echo.
    echo  This tool is for Windows 11 only.
    echo  Your Windows build is %BUILD%, which already uses the classic menu.
    echo.
    pause
    exit /b 0
)

:menu
cls
call :status
echo ================================================
echo        Windows 11 Context Menu Switcher
echo ================================================
echo.
echo  Current menu: %LABEL%
echo.
echo  [1] Use the classic context menu (all options)
echo  [2] Use the modern Windows 11 context menu
echo  [3] Exit
echo.
choice /c 123 /n /m " Choose 1, 2 or 3: "
if errorlevel 3 exit /b 0
if errorlevel 2 goto modern
if errorlevel 1 goto classic
goto menu

:classic
if "%MODE%"=="classic" (
    echo.
    echo  The classic menu is already active. Nothing was changed.
    echo.
    pause
    goto menu
)
reg add "%KEY%\InprocServer32" /f /ve >nul 2>&1
if errorlevel 1 goto error
echo.
echo  Done: the classic context menu is now enabled.
goto restart_explorer

:modern
if "%MODE%"=="modern" (
    echo.
    echo  The modern Windows 11 menu is already active. Nothing was changed.
    echo.
    pause
    goto menu
)
reg delete "%KEY%" /f >nul 2>&1
if errorlevel 1 goto error
echo.
echo  Done: the modern Windows 11 context menu is now enabled.
goto restart_explorer

:restart_explorer
echo.
echo  File Explorer must restart to apply the change.
echo  Open File Explorer windows will close (your files are not affected).
choice /c YN /n /m " Restart File Explorer now? [Y/N]: "
if errorlevel 2 (
    echo.
    echo  OK. The change will apply after you sign out or restart the PC.
    echo.
    pause
    exit /b 0
)
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul
start "" explorer.exe
echo.
echo  File Explorer was restarted. The new menu is ready.
echo.
pause
exit /b 0

:error
echo.
echo  The change could not be saved to the registry.
echo  This usually means a security program or a company policy is
echo  blocking registry changes on this PC.
echo.
pause
exit /b 1

rem --- Reads the current state into MODE and LABEL ---
:status
set "MODE=classic"
set "LABEL=Classic (all options)"
reg query "%KEY%\InprocServer32" >nul 2>&1
if not errorlevel 1 exit /b 0
set "MODE=modern"
set "LABEL=Modern Windows 11"
exit /b 0
