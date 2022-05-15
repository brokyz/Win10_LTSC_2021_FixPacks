@echo off
set BASE_DIR=%~dp0
if /i "%PROCESSOR_ARCHITECTURE%" equ "AMD64" (set "arch=x64") else (set "arch=x86")

if %arch%==x64 (goto :test1) else (goto :test2)

:test1
echo x64
PowerShell Add-AppxPackage -Path "%BASE_DIR%Microsoft.VCLibs.140.00_14.0.30704.0_x64__8wekyb3d8bbwe.Appx"
goto :end

:test2
echo x32
PowerShell Add-AppxPackage -Path "%BASE_DIR%Microsoft.VCLibs.140.00_14.0.30704.0_x86__8wekyb3d8bbwe.Appx"
goto :end

:end
pause