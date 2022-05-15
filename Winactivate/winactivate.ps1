[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $ForceKMS38,
    [Parameter()]
    [switch]
    $Headless,
    [Parameter()]
    [string]
    $ProductKey
)

function Activate-Windows {

    process {
        Invoke-CimMethod -MethodName 'Activate' -Query 'SELECT * FROM SoftwareLicensingProduct WHERE ApplicationID = ''55c92734-d682-4d71-983e-d6ec3f16059f'' AND PartialProductKey IS NOT NULL' -ErrorAction Stop | Out-Null
    }

}

function Exit-Script {

    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [int]
        $ExitCode = 0
    )

    process {
        $TemporaryFiles = @(
            'gatherosstatemodified.exe'
            'GenuineTicket.xml'
        )

        foreach ($TemporaryFile in $TemporaryFiles) {
            if (Test-Path -Path $TemporaryFile) {
                Remove-Item -Path $TemporaryFile -Force
            }
        }

        Pop-Location

        if (!$Headless.IsPresent) {
            Pause
        }

        Exit $ExitCode
    }

}

function Get-BuildNumber {

    process {
        [int](Get-CimInstance -Query 'SELECT BuildNumber FROM Win32_OperatingSystem').BuildNumber
    }

}

function Get-HWIDProductKey {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [int]
        $SkuId,
        [Parameter(Mandatory = $true, Position = 1)]
        [int]
        $Build
    )

    process {
        $ProductKey = $null

        $ProductKeys = @{
            4   = 'XGVPP-NMH47-7TTHJ-W3FW7-8HV2C'
            27  = '3V6Q6-NQXCX-V8YXR-9QCYV-QPFCT'
            48  = 'VK7JG-NPHTM-C97JM-9MPGT-3V66T'
            49  = '2B87N-8KFHP-DKV6R-Y2C8J-PKCKT'
            98  = '4CPRK-NM3K3-X6XXQ-RXX86-WXCHW'
            99  = 'N2434-X9D7W-8PF6X-8DV9T-8TYMD'
            100 = 'BT79Q-G7N6G-PGBYW-4YWX6-6F4BT'
            101 = 'YTMG3-N6DKC-DKB77-7M9GH-8HVX7'
            121 = 'YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY'
            122 = '84NGF-MHBT6-FXBX8-QWJK7-DRR8H'
            161 = 'DXG7C-N36C4-C4HTG-X4T3X-2YV77'
            162 = 'WYPNQ-8C467-V2W6J-TX4WX-WT2RQ'
            164 = '8PTT6-RNW4C-6V7J2-C2D3X-MHBPB'
            165 = 'GJTYN-HDMQY-FRR76-HVGC7-QPF8P'
            175 = 'NJCF7-PW8QT-3324D-688JX-2YV66'
            188 = 'XQQYW-NFFMW-XJPBH-K8732-CKFFD'
            191 = 'QPM6N-7J2WJ-P88HH-P3YRH-YY74H'
            203 = 'KY7PN-VR6RX-83W6Y-6DDYQ-T6R4W'
        }

        if ($null -ne $ProductKeys[$SkuId]) {
            $ProductKey = $ProductKeys[$SkuId]
        }

        switch ($Build) {
            {$_ -eq 10240} {
                $ProductKeys = @{
                    125 = 'FWN7H-PF93Q-4GGP8-M8RF3-MDWWW'
                    126 = '8V8WN-3GXBH-2TCMG-XHRX3-9766K'
                }
            }
            {$_ -eq 14393} {
                $ProductKeys = @{
                    125 = 'NK96Y-D9CD8-W44CQ-R8YTK-DYJWX'
                    126 = '2DBW3-N2PJG-MVHW3-G7TDK-9HKR4'
                }
            }
            {$_ -eq 17763} {
                $ProductKeys = @{
                    125 = '43TBQ-NH92J-XKTM7-KT3KK-P39PB'
                    126 = 'M33WV-NHY3C-R7FPM-BQGPT-239PG'
                }
            }
        }

        if ($null -ne $ProductKeys[$SkuId]) {
            $ProductKey = $ProductKeys[$SkuId]
        }

        $ProductKey
    }

}

function Get-KMS38ProductKey {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [int]
        $SkuId,
        [Parameter(Mandatory = $true, Position = 1)]
        [int]
        $Build
    )

    process {
        $ProductKey = $null

        $ProductKeys = @{
            4   = 'NPPR9-FWDCX-D2C8J-H872K-2YT43'
            27  = 'DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4'
            48  = 'W269N-WFGWX-YVC9B-4J6C9-T83GX'
            49  = 'MH37W-N47XK-V7XM9-C7227-GCQG9'
            98  = '3KHY7-WNT83-DGQKR-F7HPR-844BM'
            99  = 'PVMJN-6DFY6-9CCP6-7BKTT-D3WVR'
            100 = '7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH'
            101 = 'TX9XD-98N7V-6WMQ6-BX7FG-H8Q99'
            121 = 'NW6C2-QMPVW-D7KKK-3GKT6-VCFB2'
            122 = '2WH4N-8QGBV-H22JP-CT43Q-MDWWJ'
            161 = 'NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J'
            162 = '9FNHH-K3HBT-3W4TD-6383H-6XYWF'
            164 = '6TP4R-GNPTD-KYYHQ-7B7DP-J447Y'
            165 = 'YVWGF-BXNMC-HTQYQ-CPQ99-66QFC'
            171 = 'YYVX9-NTFWV-6MDM3-9PT4T-4M68B'
            172 = '44RPN-FTY23-9VTTB-MP9BX-T84FV'
            175 = '7NBT4-WGBQX-MP4H7-QXFF8-YP3KX'
        }

        if ($null -ne $ProductKeys[$SkuId]) {
            $ProductKey = $ProductKeys[$SkuId]
        }

        switch ($Build) {
            {$_ -eq 10240} {
                $ProductKeys = @{
                    125 = 'WNMTR-4C88C-JK8YV-HQ7T2-76DF9'
                    126 = '2F77B-TNFGY-69QQF-B8YKP-D69TJ'
                }
            }
            {$_ -eq 14393} {
                $ProductKeys = @{
                    7   = 'WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY'
                    8   = 'CB7KF-BWN84-R7R2Y-793K2-8XDDG'
                    50  = 'JCKRF-N37P4-C2D82-9YXRT-4M63B'
                    125 = 'DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ'
                    126 = 'QFFDN-GRT3P-VKWWX-X7T3R-8B639'
                    145 = '2HXDN-KRXHB-GPYC7-YCKFJ-7FVDG'
                    146 = 'PTXN8-JFHJM-4WC78-MPCBR-9W4KR'
                    168 = 'VP34G-4NPPG-79JTQ-864T4-R3MQX'
                }
            }
            {$_ -eq 17763} {
                $ProductKeys = @{
                    7   = 'N69G4-B89J2-4G8F4-WWYCC-J464C'
                    8   = 'WMDGN-G9PQG-XVVXX-R3X43-63DFG'
                    50  = 'WVDHN-86M7X-466P6-VHXV7-YY726'
                    125 = 'M7XTQ-FN8P6-TTKYV-9D4CC-J462D'
                    126 = '92NFX-8DJQP-P6BBQ-THF9C-7CG2H'
                    145 = '6NMRW-2C8FM-D24W7-TQWMY-CWH2D'
                    146 = 'N2KJX-J94YW-TQVFB-DG9YT-724CC'
                    168 = 'FDNH6-VW9RW-BXPJ7-4XTYG-239TB'
                }
            }
            {$_ -eq 19044} {
                $ProductKeys = @{
                    125 = 'M7XTQ-FN8P6-TTKYV-9D4CC-J462D'
                    126 = '92NFX-8DJQP-P6BBQ-THF9C-7CG2H'
                }
            }
            {$_ -ge 20348} {
                $ProductKeys = @{
                    7   = 'VDYBN-27WPP-V4HQT-9VMD4-VMK7H'
                    8   = 'WX4NM-KYWYW-QJJR4-XV3QB-6VM33'
                    145 = 'QFND9-D3Y9C-J3KKY-6RPVP-2DPYV'
                    146 = '67KN8-4FYJW-2487Q-MQ2J7-4C4RG'
                    168 = '6N379-GGTMK-23C6M-XVVTC-CKFRQ'
                }
            }
        }

        if ($null -ne $ProductKeys[$SkuId]) {
            $ProductKey = $ProductKeys[$SkuId]
        }

        $ProductKey
    }

}

function Get-LicenseStatus {

    process {
        [int](Get-CimInstance -Query 'SELECT LicenseStatus FROM SoftwareLicensingProduct WHERE ApplicationID = ''55c92734-d682-4d71-983e-d6ec3f16059f'' AND PartialProductKey IS NOT NULL').LicenseStatus
    }

}

function Get-SKU {

    process {
        [int](Get-CimInstance -Query 'SELECT OperatingSystemSKU FROM Win32_OperatingSystem').OperatingSystemSKU
    }

}

function Install-ProductKey {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $ProductKey
    )

    process {
        Invoke-CimMethod -Arguments @{'ProductKey' = $ProductKey} -MethodName 'InstallProductKey' -Query 'SELECT * FROM SoftwareLicensingService' -ErrorAction Stop | Out-Null
    }

}

function Set-KeyManagementServiceMachine {

    process {
        Invoke-CimMethod -Arguments @{'MachineName' = '127.0.0.1'} -MethodName 'SetKeyManagementServiceMachine' -Query 'SELECT * FROM SoftwareLicensingProduct WHERE ApplicationID = ''55c92734-d682-4d71-983e-d6ec3f16059f'' AND PartialProductKey IS NOT NULL' -ErrorAction Stop | Out-Null
    }

}

function Test-AdministrativePrivileges {

    process {
        ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }

}

function Test-KMS38ProductKey {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $ProductKey
    )

    process {
        $KMS38ProductKeys = @(
            '2F77B-TNFGY-69QQF-B8YKP-D69TJ'
            '2HXDN-KRXHB-GPYC7-YCKFJ-7FVDG'
            '2WH4N-8QGBV-H22JP-CT43Q-MDWWJ'
            '3KHY7-WNT83-DGQKR-F7HPR-844BM'
            '44RPN-FTY23-9VTTB-MP9BX-T84FV'
            '67KN8-4FYJW-2487Q-MQ2J7-4C4RG'
            '6N379-GGTMK-23C6M-XVVTC-CKFRQ'
            '6NMRW-2C8FM-D24W7-TQWMY-CWH2D'
            '6TP4R-GNPTD-KYYHQ-7B7DP-J447Y'
            '7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH'
            '7NBT4-WGBQX-MP4H7-QXFF8-YP3KX'
            '92NFX-8DJQP-P6BBQ-THF9C-7CG2H'
            '92NFX-8DJQP-P6BBQ-THF9C-7CG2H'
            '9FNHH-K3HBT-3W4TD-6383H-6XYWF'
            'CB7KF-BWN84-R7R2Y-793K2-8XDDG'
            'DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ'
            'DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4'
            'FDNH6-VW9RW-BXPJ7-4XTYG-239TB'
            'JCKRF-N37P4-C2D82-9YXRT-4M63B'
            'M7XTQ-FN8P6-TTKYV-9D4CC-J462D'
            'M7XTQ-FN8P6-TTKYV-9D4CC-J462D'
            'MH37W-N47XK-V7XM9-C7227-GCQG9'
            'N2KJX-J94YW-TQVFB-DG9YT-724CC'
            'N69G4-B89J2-4G8F4-WWYCC-J464C'
            'NPPR9-FWDCX-D2C8J-H872K-2YT43'
            'NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J'
            'NW6C2-QMPVW-D7KKK-3GKT6-VCFB2'
            'PTXN8-JFHJM-4WC78-MPCBR-9W4KR'
            'PVMJN-6DFY6-9CCP6-7BKTT-D3WVR'
            'QFFDN-GRT3P-VKWWX-X7T3R-8B639'
            'QFND9-D3Y9C-J3KKY-6RPVP-2DPYV'
            'TX9XD-98N7V-6WMQ6-BX7FG-H8Q99'
            'VDYBN-27WPP-V4HQT-9VMD4-VMK7H'
            'VP34G-4NPPG-79JTQ-864T4-R3MQX'
            'W269N-WFGWX-YVC9B-4J6C9-T83GX'
            'WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY'
            'WMDGN-G9PQG-XVVXX-R3X43-63DFG'
            'WNMTR-4C88C-JK8YV-HQ7T2-76DF9'
            'WVDHN-86M7X-466P6-VHXV7-YY726'
            'WX4NM-KYWYW-QJJR4-XV3QB-6VM33'
            'YVWGF-BXNMC-HTQYQ-CPQ99-66QFC'
            'YYVX9-NTFWV-6MDM3-9PT4T-4M68B'
        )

        if ($KMS38ProductKeys.Contains($ProductKey)) {
            $true
        }

        $false
    }

}

Push-Location -Path $PSScriptRoot

Write-Host @'
=============================================================
winactivate v2.0 - https://github.com/luzeadev/winactivate
=============================================================

'@

if (!(Test-AdministrativePrivileges)) {
    Write-Error 'This script requires administrative privileges.'
    Exit-Script -ExitCode 1
}

$Build = Get-BuildNumber
if ($Build -lt 10240) {
    Write-Error 'This build of Windows isn''t supported by this script.'
    Exit-Script -ExitCode 1
}

if ($ProductKey.Length -eq 0) {
    $SkuId = Get-SKU
    if ($ForceKMS38.IsPresent) {
        $ProductKey = Get-KMS38ProductKey -SkuId $SkuId -Build $Build
    } else {
        $ProductKey = Get-HWIDProductKey -SkuId $SkuId -Build $Build

        if ($ProductKey.Length -eq 0) {
            $ProductKey = Get-KMS38ProductKey -SkuId $SkuId -Build $Build
        }
    }
}

if ($null -eq $ProductKey) {
    Write-Error 'This edition of Windows isn''t supported by this script.'
    Exit-Script -ExitCode 1
}

Write-Host "Installing product key $ProductKey..."
try {
    Install-ProductKey -ProductKey $ProductKey
} catch {
    Write-Error $_
    Exit-Script -ExitCode 1
}
Write-Host 'Done.' -ForegroundColor Magenta
Write-Host

if (Test-KMS38ProductKey -ProductKey $ProductKey) {
    Write-Host 'Setting key management service machine to 127.0.0.1...'
    try {
        Set-KeyManagementServiceMachine
    } catch {
        Write-Error $_
        Exit-Script -ExitCode 1
    }
    Write-Host 'Done.' -ForegroundColor Magenta
    Write-Host
}

Write-Host 'Patching gatherosstate.exe...'
$Process = Start-Process -FilePath 'rundll32.exe' -ArgumentList """$PSScriptRoot\slc.dll"",PatchGatherosstate" -PassThru -Wait
if ($Process.ExitCode -ne 0) {
    Write-Error 'Failed to patch gatherosstate.exe.'
    Exit-Script -ExitCode 1
}
Write-Host 'Done.' -ForegroundColor Magenta
Write-Host

Write-Host 'Generating GenuineTicket.xml...'
$Process = Start-Process -FilePath "$PSScriptRoot\gatherosstatemodified.exe" -PassThru -Wait
if ($Process.ExitCode -ne 0) {
    Write-Error 'Failed to generate GenuineTicket.xml.'
    Exit-Script -ExitCode 1
}
Write-Host 'Done.' -ForegroundColor Magenta
Write-Host

Write-Host 'Applying GenuineTicket.xml...'
Copy-Item -Path "$PSScriptRoot\GenuineTicket.xml" -Destination "$env:SystemDrive\ProgramData\Microsoft\Windows\ClipSVC\GenuineTicket" -Force
$Process = Start-Process -FilePath 'ClipUp.exe' -ArgumentList '-o' -PassThru -WindowStyle Hidden -Wait
if ($Process.ExitCode -ne 0) {
    Write-Error 'Failed to apply GenuineTicket.xml.'
    Exit-Script -ExitCode 1
}
Write-Host 'Done.' -ForegroundColor Magenta
Write-Host

Write-Host 'Activating Windows...'
if (!(Test-KMS38ProductKey -ProductKey $ProductKey)) {
    try {
        Activate-Windows
    } catch {
        Write-Error $_
        Exit-Script -ExitCode 1
    }
}
$LicenseStatus = Get-LicenseStatus
if ($LicenseStatus -ne 1) {
    Write-Error 'Failed to activate Windows.'
    Exit-Script -ExitCode 1
}
Write-Host 'Done.' -ForegroundColor Magenta
Write-Host

Exit-Script -ExitCode 0
