$reg = Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing" -Name "UEFICA2023Status" -ErrorAction SilentlyContinue

Write-Output $reg.UEFICA2023Status

if ($reg.UEFICA2023Status -eq "Updated") {
    exit 0
} else {
    exit 1
}
