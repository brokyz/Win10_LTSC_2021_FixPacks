@echo off

openfiles 1>nul 2>nul || goto :administrator
if /i "%PROCESSOR_ARCHITECTURE%" equ "AMD64" (set "arch=x64") else (set "arch=x86")
set "install=PowerShell -NoLogo -NoProfile -NonInteractive  -ExecutionPolicy Bypass add-appxpackage"
if /i %arch%==x64 (goto :x64) else (goto :x86)
goto :error
:x64
for /f  "tokens=2-3 delims=." %%G in ('PowerShell get-appxpackage *vclib*') do set "ifexist=%%G" && goto :skip1
:skip1
if %ifexist%==VCLibs goto:exist
echo Microsoft.VCLibs x64 installing...
for /f %%i in ('dir /s/b %~dp0*VCLibs*x64*') do %install%  %%i && echo Microsoft.VCLibs x64 installing finished.
goto :finished
:x86
for /f  "tokens=2-3 delims=." %%G in ('PowerShell get-appxpackage *vclib*') do set "ifexist=%%G" && goto :skip3
:skip3
if %ifexist%==VCLibs goto:exist
echo Microsoft.VCLibs x86 installing...
for /f %%i in ('dir /s/b %~dp0*VCLibs*x86*') do %install%  %%i && echo Microsoft.VCLibs x86 installing finished.

:administrator
echo.
echo Please run this by administrator privilege.
echo.
goto :finished

:exist
echo.
echo Microsoft.VCLibs has already installed in your system.
echo Open PowerShell and run command "get-appxpackage *VCLibs*" to view.
echo.
goto :finished

:finished
echo.
echo Press any key...
pause >nul


