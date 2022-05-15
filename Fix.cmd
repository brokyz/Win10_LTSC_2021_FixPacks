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
echo Win10 LTSC 2021 ���bug�޸��ű�
echo ============================================================
echo.
echo 1. ���� Win10 LTSC 2021 
echo 2. ��װ΢���̵꣨��ѡ��޸�wsappx�����CPUռ�ú�΢��ƴ�����뷨����ʾ��ѡ�ʵ�bug��
echo 3. �˳�
echo.
echo ============================================================
echo.
echo ��ѡ����Ҫ��ѡ��س�:
set /p opt=
if %opt%==1 goto :activate
if %opt%==2 goto :installMicrosoftStore
if %opt%==3 goto :exit
echo ����: ��������ѡ��
goto :first


:activate
echo.
call %ROOT_DIR%Winactivate\winactivate.cmd
echo.
echo ����ɹ�
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
echo ��װ Microsoft Store...
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
echo ��װ Store Purchase App...
echo ============================================================
echo.
1>nul 2>nul %PScommand% Add-AppxProvisionedPackage -Online -PackagePath %PurchaseApp% -DependencyPackagePath %DepPurchase% -LicensePath Microsoft.StorePurchaseApp_8wekyb3d8bbwe.xml
%PScommand% Add-AppxPackage -Path %PurchaseApp%
)
if defined AppInstaller (
echo.
echo ============================================================
echo ��װ App Installer...
echo ============================================================
echo.
1>nul 2>nul %PScommand% Add-AppxProvisionedPackage -Online -PackagePath %AppInstaller% -DependencyPackagePath %DepInstaller% -LicensePath Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.xml
%PScommand% Add-AppxPackage -Path %AppInstaller%
)
if defined XboxIdentity (
echo.
echo ============================================================
echo ��װ Xbox Identity Provider...
echo ============================================================
echo.
1>nul 2>nul %PScommand% Add-AppxProvisionedPackage -Online -PackagePath %XboxIdentity% -DependencyPackagePath %DepXbox% -LicensePath Microsoft.XboxIdentityProvider_8wekyb3d8bbwe.xml
%PScommand% Add-AppxPackage -Path %XboxIdentity%
)
echo.
echo ���
echo.
echo �����������������������
pause >nul
goto :first


:nofiles
echo.
echo ����: ȱ������Ҫ�İ�װ�ļ�
echo.
echo �����������������������
pause >nul
goto :first

:version
echo.
echo ����: ���windows�汾�� %ver%
echo ����: ΢���̵��֧��1709�������ϵ�windows�汾
echo.
echo �����������������������
pause >nul
goto :first


:administrator
echo.
echo ����: ���ű���Ҫ����ԱȨ�޲ſ����� (���Ҽ�������ѡ���Թ���Ա����Ա�������)
echo.
echo ��������������˳��ű�
pause >nul
goto :exit

:exit
exit
