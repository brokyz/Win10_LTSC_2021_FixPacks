@echo off
@REM brokyz

openfiles 1>nul 2>nul || goto :administrator
if /i "%PROCESSOR_ARCHITECTURE%" equ "AMD64" (set "arch=x64") else (set "arch=x86")
set ROOT_DIR=%~dp0

:first
echo.
echo %ROOT_DIR%
echo.
echo ============================================================
echo Win10 LTSC 2021 FixPacks
echo ============================================================
echo.
echo 1. Activate Win10 LTSC 2021 
echo 2. Fix-LTSC2021
echo 3. Add MicrosoftStore
echo 4. Exit
echo.
echo ============================================================
echo.
echo Chose the option you need:
set /p opt=
if %opt%==1 goto :activate
if %opt%==2 goto :fix
if %opt%==3 goto :installMicrosoftStore
if %opt%==4 goto :exit
echo error: Please check you input.
goto :first


:activate
echo.
call %ROOT_DIR%Winactivate\winactivate.cmd
echo.
echo finished.
echo .
goto :first

:fix
echo.
call %ROOT_DIR%Fix-LTSC2021\Fix-LTSC2021.cmd
echo.
echo finished.
echo .
goto :first


:installMicrosoftStore
echo.
call %ROOT_DIR%Add-Store\Add-Store.cmd
echo.
echo finished.
echo.
goto :first


:administrator
echo.
echo Please run this by administrator privilege.
echo.
:exit
exit
