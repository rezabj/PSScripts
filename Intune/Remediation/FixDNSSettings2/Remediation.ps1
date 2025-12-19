# Removing static DNS server addresses to allow DHCP to manage DNS settings

# Detection Script for Static DNS Server Settings
$Interfaces = Get-NetAdapter | Select-Object ifIndex, Name, InterfaceDescription, InterfaceGuid

foreach ($Interface in $Interfaces) {
    if ($Interface.InterfaceDescription -notlike "*forti*") {
        Write-Output "Resetting DNS server addresses for interface: $($Interface.Name)"
        Set-DnsClientServerAddress -InterfaceIndex $Interface.ifIndex -ResetServerAddresses -ErrorAction SilentlyContinue
    }
}

Write-Output "Static DNS server settings have been removed. DHCP will now manage DNS settings."
exit 0