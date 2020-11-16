#requires -version 4
<#
.SYNOPSIS
  Get users with old password.
.DESCRIPTION
  Script create Excel report of users with to old password.
.PARAMETER UsersContainer
    AD SearchBase.
.PARAMETER Days
    Determine how old password can be used. Default is 90.
.PARAMETER Path
    Where report will be saved.
.INPUTS
  <Inputs if any, otherwise state None>
.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>
.NOTES
  Version:        1.0
  Author:         Jan Řežab
  Purpose/Change: 
  
.EXAMPLE
  .\Get-UsersPasswordAge.ps1 -UsersContainer "OU=HeadOffice,DC=contoso,DC=com" -Path C:\Reports\test_report.xlsx
#>
#---------------------------------------------------------[Parameters]-------------------------------------------------------------
param (
        # This is the same as .Parameter
        [string]$UsersContainer,
        [int]$Days = "90",
        [string]$Path = "$env:TEMP\Report-ADOldPasswdUsers.xlsx"
    )
#---------------------------------------------------------[Initialisations]--------------------------------------------------------

Import-Module -Name Logging
Import-Module -Name ActiveDirectory
Import-Module -Name ImportExcel

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Logging
<#
$LogPath = "C:\Tmp\"
$LogName = $MyInvocation.MyCommand.Name + "-" + (Get-Date -Format "yyyyMMdd-HHmmss") +  ".log"
$LogFile = $LogPath + $LogName
#>
Set-LoggingDefaultLevel -Level 'DEBUG'
Add-LoggingTarget -Name Console
<#
Add-LoggingTarget -Name File -Configuration @{
  Path = $LogFile
  Encoding = "UTF8"
}
#>

$CurrentDate = Get-Date

#-----------------------------------------------------------[Functions]------------------------------------------------------------

#-----------------------------------------------------------[Execution]------------------------------------------------------------

### Try connect to AD.
try {
  $Domain = Get-ADDomain
} catch {
  Write-Log -Level ERROR -Message "Can not connect to AD."
  throw $_
} Finally {
    $m = "Checking domain " + $Domain.DistinguishedName + "."
    Write-Log -Level INFO -Message $m
    Write-Log -Level INFO -Message "PS> Get-ADDomain"
}


### Get users with old or never set password.
if (!$UsersContainer) {
    $m = "Getting users from " + $Domain.UsersContainer + "."
    Write-Log -Level INFO -Message $m
    $ADUsers = Get-ADUser -Filter * -ResultSetSize $null -SearchBase $Domain.UsersContainer -Properties PasswordLastSet,PasswordNeverExpires | Where-Object { $_.PasswordLastSet -lt $CurrentDate.AddDays(-$Days) }
} else {
    $m = "Getting users from " + $UsersContainer + "."
    Write-Log -Level INFO -Message $m
    $ADUsers = Get-ADUser -Filter * -ResultSetSize $null -SearchBase $UsersContainer -Properties PasswordLastSet,PasswordNeverExpires | Where-Object { $_.PasswordLastSet -lt $CurrentDate.AddDays(-$Days) }
}

### Create report
$BadUsers = $ADUsers | Select-Object GivenName,Name,Surname,DistinguishedName,Enabled,PasswordNeverExpires,PasswordLastSet,UserPrincipalName,ObjectGUID,SamAccountName,SID 
try {
    Export-Excel -Path $Path -InputObject $BadUsers -WorksheetName "Users" -AutoSize -AutoFilter -Show
} catch {
    Write-Log -Level ERROR -Message "ERROR: Can't create report."
    throw $_
} Finally {
    Write-Log -Level INFO -Message "Report created."
}

Wait-Logging
