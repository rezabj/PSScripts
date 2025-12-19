# Removing static DNS server addresses to allow DHCP to manage DNS settings
$RegPath = "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"

$Interfaces = Get-ChildItem -Path $RegPath

foreach ($Interface in $Interfaces) {
    $DnsServers = Get-ItemProperty -Path $Interface.PSPath -Name "NameServer" -ErrorAction SilentlyContinue

    if (![string]::IsNullOrEmpty($DnsServers.NameServer)) {
        Write-Output "Removing static DNS settings from interface: $($Interface.PSChildName)"
        # Clear the NameServer value to remove static DNS settings
        Set-ItemProperty -Path $Interface.PSPath -Name "NameServer" -Value ""
    }
}

Write-Output "Static DNS server settings have been removed. DHCP will now manage DNS settings."
exit 0