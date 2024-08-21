$AppsToUpgrade = @(
    "7zip.7zip",
    "Adobe.Acrobat.Reader.64-bit",
    "PuTTY.PuTTY",
    "Microsoft.Office"
)

try {
  Import-Module -name Cobalt -Force
}
catch {
  Write-Error "Cobalt PowerShell module not found"
  exit 1
}

$WinGet = Get-AppxPackage -Name "Microsoft.DesktopAppInstaller" -AllUsers | Select-Object -Property Name, Version, InstallLocation
If (!$WinGet) {
    Write-Host "Microsoft.DesktopAppInstaller not found"
    exit 1
}

$AvailableUpdates = Get-WinGetPackageUpdate

$UpgradeAvailable = $false
foreach ($App in $AppsToUpgrade) {
    if ($AvailableUpdates.Id -in $AppsToUpgrade) {
        $UpgradeAvailable = $true
    }
}

if ($UpgradeAvailable) {
	Write-Host "Upgrade available for 1 or more apps"
	exit 1
} else {
	Write-Host "No Upgrade available"
	exit 0
}