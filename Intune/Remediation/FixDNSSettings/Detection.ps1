# Detection Script for Static DNS Server Settings
$RegPath = "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"

$Interfaces = Get-ChildItem -Path $RegPath

$hasStaticDns = $false

foreach ($Interface in $Interfaces) {
    $DnsServers = Get-ItemProperty -Path $Interface.PSPath -Name "NameServer" -ErrorAction SilentlyContinue

    if (![string]::IsNullOrEmpty($DnsServers.NameServer)) {
        Write-Output "Static DNS detected on interface: $($Interface.PSChildName)"
        $hasStaticDns = $true
    }
}

if ($hasStaticDns) {
    exit 1
} else {
    Write-Output "No static DNS server settings detected."
    exit 0
}