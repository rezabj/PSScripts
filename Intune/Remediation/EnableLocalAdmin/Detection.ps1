$localAdmin = Get-LocalUser | Where-Object { $_.SID -like "S-1-5-21-*-500" }

if ($localAdmin.enabled -eq $false) {
    Write-Output "Local admin account is disabled"
    exit 1
} else {
    Write-Output "Local admin account is enabled"
    exit 0
}