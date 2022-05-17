@echo off
openfiles 1>nul 2>nul || goto :administrator
if /i "%PROCESSOR_ARCHITECTURE%" equ "AMD64" (set "arch=x64") else (set "arch=x86")
set "install=PowerShell -NoLogo -NoProfile -NonInteractive  -ExecutionPolicy Bypass add-appxpackage"
if /i %arch%==x64 (goto :x64) else (goto :x86)
goto :error
:x64
echo.
echo Microsoft.NET.Native.Framework x64 installing...
for /f %%i in ('dir /s/b %~dp0*NET.Native.Framework*x64*') do %install%  %%i && echo Microsoft.NET.Native.Framework x64 installing finished
echo.
echo Microsoft.NET.Native.Runtime x64 installing...
for /f %%i in ('dir /s/b %~dp0*NET.Native.Runtime*x64*') do %install%  %%i && echo Microsoft.NET.Native.Runtime x64 installing finished
echo.
echo Microsoft.UI.Xaml x64 installing...
for /f %%i in ('dir /s/b %~dp0*UI.Xaml*x64*') do %install%  %%i && echo Microsoft.UI.Xaml x64 installing finished
for /f  "tokens=2-3 delims=." %%G in ('PowerShell get-appxpackage *vclib*') do  if %%G==VCLibs (goto :skipVCLibsx64)
echo.
echo Microsoft.VCLibs x64 installing...
for /f %%i in ('dir /s/b %~dp0*VCLibs*x64*') do %install%  %%i && echo Microsoft.VCLibs x64 installing finished
:skipVCLibsx64
for /f  "tokens=2-3 delims=." %%G in ('PowerShell get-appxpackage *vclib*UWP*') do  if %%G==VCLibs (goto :skipVCLibsUWPx64)
echo.
echo Microsoft.VCLibs UWP x64 installing...
for /f %%i in ('dir /s/b %~dp0*VCLibs*UWP*x64*') do %install%  %%i && echo Microsoft.VCLibs UWP x64 installing finished
:skipVCLibsUWPx64
echo.
echo Microsoft.WindowsStore installing...
for /f %%i in ('dir /s/b %~dp0*WindowsStore*') do %install%  %%i && echo Microsoft.WindowsStore installing finished
echo.
echo DesktopAppInstaller x64 installing...
for /f %%i in ('dir /s/b %~dp0*DesktopAppInstaller*') do %install%  %%i && echo DesktopAppInstaller x64 installing finished
goto :finished
:x86
echo.
echo Microsoft.NET.Native.Framework x86 installing...
for /f %%i in ('dir /s/b %~dp0*NET.Native.Framework*x86*') do %install%  %%i && echo Microsoft.NET.Native.Framework x86 installing finished
echo.
echo Microsoft.NET.Native.Runtime x86 installing...
for /f %%i in ('dir /s/b %~dp0*NET.Native.Runtime*x86*') do %install%  %%i && echo Microsoft.NET.Native.Runtime x86 installing finished
echo.
echo Microsoft.UI.Xaml x86 installing...
for /f %%i in ('dir /s/b %~dp0*UI.Xaml*x86*') do %install%  %%i && echo Microsoft.UI.Xaml x86 installing finished
for /f  "tokens=2-3 delims=." %%G in ('PowerShell get-appxpackage *vclib*') do  if %%G==VCLibs (goto :skipVCLibsx86)
echo.
echo Microsoft.VCLibs x86 installing...
for /f %%i in ('dir /s/b %~dp0*VCLibs*x86*') do %install%  %%i && echo Microsoft.VCLibs x86 installing finished
:skipVCLibsx86
for /f  "tokens=2-3 delims=." %%G in ('PowerShell get-appxpackage *vclib*UWP*') do  if %%G==VCLibs (goto :skipVCLibsUWPx86)
echo.
echo Microsoft.VCLibs UWP x86 installing...
for /f %%i in ('dir /s/b %~dp0*VCLibs*UWP*x86*') do %install%  %%i && echo Microsoft.VCLibs UWP x86 installing finished
:skipVCLibsUWPx86
echo.
echo Microsoft.WindowsStore installing...
for /f %%i in ('dir /s/b %~dp0*WindowsStore*') do %install%  %%i && echo Microsoft.WindowsStore installing finished
echo.
echo DesktopAppInstaller installing...
for /f %%i in ('dir /s/b %~dp0*DesktopAppInstaller*') do %install%  %%i && echo DesktopAppInstaller installing finished

:administrator
echo.
echo Please run this by administrator privilege.
echo.
goto :finished
:error
echo error: Can not detect system arch.
goto :finished
:finished
echo.
echo Press any key...
pause >nul