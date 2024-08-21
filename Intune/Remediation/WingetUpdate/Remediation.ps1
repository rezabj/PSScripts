$AppsToUpgrade = @(
    "7zip.7zip",
    "Adobe.Acrobat.Reader.64-bit",
    "PuTTY.PuTTY",
    "Microsoft.Office"
)

Import-Module -name Cobalt -RequiredVersion "0.4.0" -Force

$AvailableUpdates = Get-WinGetPackageUpdate

try {
    $winget = Join-Path -Path (get-AppxPackage -Name "Microsoft.DesktopAppInstaller" -AllUsers).InstallLocation -ChildPath "winget.exe"
    
    foreach ($AppToUpdate in $AvailableUpdates) {
      if ($AppToUpdate.Id -in $AppsToUpgrade) {
        & $winget upgrade --exact $app --silent --force --accept-package-agreements --accept-source-agreements
        Write-Host "Upgrading $($AppToUpdate | convertto-json -Compress)"
      }
    }
    exit 0
} catch {
    Write-Error "Error while installing upgrades."
    exit 1
}