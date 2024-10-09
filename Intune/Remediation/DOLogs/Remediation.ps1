$date = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
$LogPath = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\DeliveryOptimizationLog-$date.txt"

Get-DeliveryOptimizationLog -Flush | Set-Content -Path $LogPath

exit 0