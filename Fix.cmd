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
echo Win10 LTSC 2021 相关bug修复脚本
echo ============================================================
echo.
echo 1. 激活 Win10 LTSC 2021 
echo 2. 安装微软商店（此选项将修复wsappx服务高CPU占用和微软拼音输入法不显示候选词的bug）
echo 3. 退出
echo.
echo ============================================================
echo.
echo 请选择需要的选项并回车:
set /p opt=
if %opt%==1 goto :activate
if %opt%==2 goto :installMicrosoftStore
if %opt%==3 goto :exit
echo 错误: 请检查输入选项
goto :first


:activate
echo.
call %ROOT_DIR%Winactivate\winactivate.cmd
echo.
echo 激活成功
echo .
goto :first


:installMicrosoftStore
echo.
for /f  "tokens=3 delims=." %%G in ('ver') do if %%G lss 16299 set /a ver = %%G && goto :version

if not exist "%ROOT_DIR%MicrosoftStore\*WindowsStore*.appxbundle" goto :nofiles
if not exist "%ROOT_DIR%MicrosoftStore\*WindowsStore*.xml" goto :nofiles

for /f %%i in ('dir /s/b %ROOT_DIR%MicrosoftStore\*WindowsStore*.appxbundle 2^>nul') do set "Store=%%i"
for /f %%i in ('dir /s/b %ROOT_DIR%MicrosoftStore\*NET.Native.Framework*1.6*.appx 2^>nul ^| find /i "x64"') do set "Framework6X64=%%i"
for /f %%i in ('dir /s/b %ROOT_DIR%MicrosoftStore\*NET.Native.Framework*1.6*.appx 2^>nul ^| find /i "x86"') do set "Framework6X86=%%i"
for /f %%i in ('dir /s/b %ROOT_DIR%MicrosoftStore\*NET.Native.Runtime*1.6*.appx 2^>nul ^| find /i "x64"') do set "Runtime6X64=%%i"
for /f %%i in ('dir /s/b %ROOT_DIR%MicrosoftStore\*NET.Native.Runtime*1.6*.appx 2^>nul ^| find /i "x86"') do set "Runtime6X86=%%i"
for /f %%i in ('dir /s/b %ROOT_DIR%MicrosoftStore\*VCLibs*140*.appx 2^>nul ^| find /i "x64"') do set "VCLibsX64=%%i"
for /f %%i in ('dir /s/b %ROOT_DIR%MicrosoftStore\*VCLibs*140*.appx 2^>nul ^| find /i "x86"') do set "VCLibsX86=%%i"

if exist "%ROOT_DIR%MicrosoftStore\*StorePurchaseApp*.appxbundle" if exist "%ROOT_DIR%MicrosoftStore\*StorePurchaseApp*.xml" (
for /f %%i in ('dir /s/b %ROOT_DIR%MicrosoftStore\*StorePurchaseApp*.appxbundle 2^>nul') do set "PurchaseApp=%%i"
)
if exist "%ROOT_DIR%MicrosoftStore\*DesktopAppInstaller*.appxbundle" if exist "%ROOT_DIR%MicrosoftStore\*DesktopAppInstaller*.xml" (
for /f %%i in ('dir /s/b %ROOT_DIR%MicrosoftStore\*DesktopAppInstaller*.appxbundle 2^>nul') do set "AppInstaller=%%i"
)
if exist "%ROOT_DIR%MicrosoftStore\*XboxIdentityProvider*.appxbundle" if exist "%ROOT_DIR%MicrosoftStore\*XboxIdentityProvider*.xml" (
for /f %%i in ('dir /s/b %ROOT_DIR%MicrosoftStore\*XboxIdentityProvider*.appxbundle 2^>nul') do set "XboxIdentity=%%i"
)

if /i %arch%==x64 (
set "DepStore=%VCLibsX64%,%VCLibsX86%,%Framework6X64%,%Framework6X86%,%Runtime6X64%,%Runtime6X86%"
set "DepPurchase=%VCLibsX64%,%VCLibsX86%,%Framework6X64%,%Framework6X86%,%Runtime6X64%,%Runtime6X86%"
set "DepXbox=%VCLibsX64%,%VCLibsX86%,%Framework6X64%,%Framework6X86%,%Runtime6X64%,%Runtime6X86%"
set "DepInstaller=%VCLibsX64%,%VCLibsX86%"
) else (
set "DepStore=%VCLibsX86%,%Framework6X86%,%Runtime6X86%"
set "DepPurchase=%VCLibsX86%,%Framework6X86%,%Runtime6X86%"
set "DepXbox=%VCLibsX86%,%Framework6X86%,%Runtime6X86%"
set "DepInstaller=%VCLibsX86%"
)

for %%i in (%DepStore%) do (
if not exist "%%i" goto :nofiles
)

set "PScommand=PowerShell -NoLogo -NoProfile -NonInteractive -InputFormat None -ExecutionPolicy Bypass"

echo.
echo ============================================================
echo 安装 Microsoft Store...
echo ============================================================
echo.
1>nul 2>nul %PScommand% Add-AppxProvisionedPackage -Online -PackagePath %Store% -DependencyPackagePath %DepStore% -LicensePath Microsoft.WindowsStore_8wekyb3d8bbwe.xml
for %%i in (%DepStore%) do (
%PScommand% Add-AppxPackage -Path %%i
)
%PScommand% Add-AppxPackage -Path %Store%

if defined PurchaseApp (
echo.
echo ============================================================
echo 安装 Store Purchase App...
echo ============================================================
echo.
1>nul 2>nul %PScommand% Add-AppxProvisionedPackage -Online -PackagePath %PurchaseApp% -DependencyPackagePath %DepPurchase% -LicensePath Microsoft.StorePurchaseApp_8wekyb3d8bbwe.xml
%PScommand% Add-AppxPackage -Path %PurchaseApp%
)
if defined AppInstaller (
echo.
echo ============================================================
echo 安装 App Installer...
echo ============================================================
echo.
1>nul 2>nul %PScommand% Add-AppxProvisionedPackage -Online -PackagePath %AppInstaller% -DependencyPackagePath %DepInstaller% -LicensePath Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.xml
%PScommand% Add-AppxPackage -Path %AppInstaller%
)
if defined XboxIdentity (
echo.
echo ============================================================
echo 安装 Xbox Identity Provider...
echo ============================================================
echo.
1>nul 2>nul %PScommand% Add-AppxProvisionedPackage -Online -PackagePath %XboxIdentity% -DependencyPackagePath %DepXbox% -LicensePath Microsoft.XboxIdentityProvider_8wekyb3d8bbwe.xml
%PScommand% Add-AppxPackage -Path %XboxIdentity%
)
echo.
echo 完成
echo.
echo 按键盘上任意键返回主界面
pause >nul
goto :first


:nofiles
echo.
echo 错误: 缺少所需要的安装文件
echo.
echo 按键盘上任意键返回主界面
pause >nul
goto :first

:version
echo.
echo 错误: 你的windows版本是 %ver%
echo 错误: 微软商店仅支持1709及其以上的windows版本
echo.
echo 按键盘上任意键返回主界面
pause >nul
goto :first


:administrator
echo.
echo 错误: 本脚本需要管理员权限才可运行 (请右键本程序，选择以管理员管理员身份运行)
echo.
echo 按键盘上任意键退出脚本
pause >nul
goto :exit

:exit
exit
