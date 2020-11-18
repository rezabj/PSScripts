#requires -version 4
<#
.SYNOPSIS
  Connect to Sharepoint Online.
.DESCRIPTION
  Script create Excel report of users with to old password.
.PARAMETER OrgName
    Organization name. E.g. "contoso". First part from url "https://contoso-admin.sharepoint.com".
.INPUTS
  <Inputs if any, otherwise state None>
.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>
.NOTES
  Version:        1.0
  Author:         Jan Řežab
  Purpose/Change: 
  
.EXAMPLE
  .\Connect-ShpOnline.ps1 -OrgName "contoso"
#>
#---------------------------------------------------------[Parameters]-------------------------------------------------------------
param (
        # This is the same as .Parameter
        [Parameter(mandatory=$true)]
        [string]$OrgName,
        [System.Management.Automation.PSCredential]$Credential
    )
#---------------------------------------------------------[Initialisations]--------------------------------------------------------

try {
    Import-Module -Name Logging,Microsoft.Online.SharePoint.PowerShell -DisableNameChecking -ErrorAction Stop
} catch {
    $m = "You need required module Logging and Microsoft.Online.SharePoint.PowerShell."
    Write-Log -Level ERROR -Message $m
    throw $_
}

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Logging
Set-LoggingDefaultLevel -Level 'DEBUG'
Add-LoggingTarget -Name Console

#-----------------------------------------------------------[Functions]------------------------------------------------------------

#-----------------------------------------------------------[Execution]------------------------------------------------------------

$Url = "https://" + $OrgName + "-admin.sharepoint.com"
Connect-SPOService -Url $Url -Credential $Credential

Wait-Logging