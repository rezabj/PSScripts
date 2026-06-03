$reg = Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecureBoot\State" -Name "UEFISecureBootEnabled" -ErrorAction SilentlyContinue

Write-Output $reg.UEFISecureBootEnabled

if ($reg.UEFISecureBootEnabled -eq 1) {
    exit 0
} else {
    exit 1
}
