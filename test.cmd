@echo off
openfiles 1nul 2nul  goto administrator
if i %PROCESSOR_ARCHITECTURE% equ AMD64 (set arch=x86) else (set arch=x86)

set install=PowerShell -NoLogo -NoProfile -NonInteractive  -ExecutionPolicy Bypass add-appxpackage

if i %arch%==x64 goto x64 else goto x86
x64
echo.
echo Microsoft.NET.Native.Framework 安装中...
for f %%i in ('dir sb %~dp0NET.Native.Frameworkx64') do %install%  %%i && echo Microsoft.NET.Native.Framework 安装成功
echo.
echo Microsoft.NET.Native.Runtime 安装中...
for f %%i in ('dir sb %~dp0NET.Native.Runtimex64') do %install%  %%i && echo Microsoft.NET.Native.Runtime 安装成功
echo.
echo 安装 Microsoft.UI.Xaml 安装中...
for f %%i in ('dir sb %~dp0UI.Xamlx64') do %install%  %%i && echo Microsoft.UI.Xaml 安装成功
echo.
for f  tokens=2-3 delims=. %%G in ('PowerShell get-appxpackage vclib') do set ifexist=%%G && goto skip1
skip1
if %ifexist%==VCLibs gotoskip2
echo 安装 Microsoft.VCLibs 安装中...
for f %%i in ('dir sb %~dp0VCLibsx64') do %install%  %%i && echo Microsoft.VCLibs 安装成功
skip2
echo.
echo 安装 Microsoft.WindowsStore 安装中...
for f %%i in ('dir sb %~dp0WindowsStore') do %install%  %%i && echo Microsoft.WindowsStore 安装成功
echo.
echo 安装DesktopAppInstaller 安装中...
for f %%i in ('dir sb %~dp0DesktopAppInstaller') do %install%  %%i && echo Microsoft.WindowsStore 安装成功
goto finished
x86
echo.
echo Microsoft.NET.Native.Framework 安装中 x86...
for f %%i in ('dir sb %~dp0NET.Native.Frameworkx86') do %install%  %%i && echo Microsoft.NET.Native.Framework 安装成功
echo.
echo Microsoft.NET.Native.Runtime 安装中...
for f %%i in ('dir sb %~dp0NET.Native.Runtimex86') do %install%  %%i && echo Microsoft.NET.Native.Runtime 安装成功
echo.
echo 安装Microsoft.UI.Xaml 安装中...
for f %%i in ('dir sb %~dp0UI.Xamlx86') do %install%  %%i && echo Microsoft.UI.Xaml 安装成功
echo.
for f  tokens=2-3 delims=. %%G in ('PowerShell get-appxpackage vclib') do set ifexist=%%G && goto skip3
skip3
if %ifexist%==VCLibs gotoskip4
echo 安装 Microsoft.VCLibs 安装中...
for f %%i in ('dir sb %~dp0VCLibsx86') do %install%  %%i && echo Microsoft.VCLibs 安装成功
skip4
echo.
echo 安装Microsoft.WindowsStore 安装中...
for f %%i in ('dir sb %~dp0WindowsStore') do %install%  %%i && echo Microsoft.WindowsStore 安装成功
echo.
echo 安装DesktopAppInstaller 安装中...
for f %%i in ('dir sb %~dp0DesktopAppInstaller') do %install%  %%i && echo Microsoft.WindowsStore 安装成功

finished
echo 微软应用商店安装成功

pause
exit