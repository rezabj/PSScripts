$localAdmin = Get-LocalUser | Where-Object { $_.SID -like "S-1-5-21-*-500" }

if ($null -eq $localAdmin) {
    Write-Output "Local admin account not found"
    exit 1
}

if ($localAdmin.Count -gt 1) {
    Write-Output "Multiple local admin accounts found"
    exit 1
}

if ($localAdmin.enabled -eq $false) {
    $localAdmin | Enable-LocalUser
    Write-Output "Enabling local admin account..."
    exit 0
} else {
    Write-Output "Local admin account is already enabled"
    exit 0
}