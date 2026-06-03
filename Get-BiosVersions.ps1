Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All"

$devices = Get-MgBetaDeviceManagementManagedDevice -All | Where-Object {$_.OperatingSystem -eq "Windows"}

$csv = @()
foreach ($device in $devices) {
  $hwinfo = Get-MgBetaDeviceManagementManagedDevice -ManagedDeviceId $device.Id -property "HardwareInformation"
  $csv += [PSCustomObject]@{
    DeviceName         = $device.DeviceName
    DeviceId           = $device.Id
    UserPrincipalName  = $device.UserPrincipalName
    LastSyncDateTime   = $device.LastSyncDateTime
    Manufacturer       = $hwinfo.HardwareInformation.Manufacturer
    Model              = $hwinfo.HardwareInformation.Model
    DeviceSerialNumber = $hwinfo.HardwareInformation.SerialNumber
    BiosVersion        = $hwinfo.HardwareInformation.SystemManagementBiosVersion
  }
}
$csv | Export-Csv -Path "BiosVersionReport.csv" -NoTypeInformation -Encoding UTF8