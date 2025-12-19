# Detection Script for Static DNS Server Settings
$RegPath = "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
$Interfaces = Get-NetAdapter | Select-Object Name, InterfaceDescription, InterfaceGuid

$hasStaticDns = $false

foreach ($Interface in $Interfaces) {
    if ($Interface.InterfaceDescription -notlike "*forti*") {
        $KeyPath = "$RegPath\$($Interface.InterfaceGuid)"    
        $DnsServers = Get-ItemProperty -Path $KeyPath -Name "NameServer" -ErrorAction SilentlyContinue
        if (![string]::IsNullOrEmpty($DnsServers.NameServer)) {
            Write-Output "Static DNS detected on interface: $($Interface.Name)"
            $hasStaticDns = $true
        }
    }
}

if ($hasStaticDns) {
    exit 1
} else {
    Write-Output "No static DNS server settings detected."
    exit 0
}