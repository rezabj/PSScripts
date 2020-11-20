<#
.SYNOPSIS
  Script to report users MFA status.
.DESCRIPTION
  This script will generate excel report for users MFA status.
.PARAMETER Path
  Specifies report path.
.INPUTS
  <Does the script accept an input>
.OUTPUTS
  A log file in the temp directory of the user running the script
.NOTES
  Version:        1.
  Author:         Jan Řežab
  Creation Date:  <Date>
  Purpose/Change: Initial script development
.EXAMPLE
  <Give multiple examples of the script if possible>
#>

#Requires -version 5.0
# Module MSOnline not work in core edition. 
#Requires -PSEdition Desktop
#Requires -Module Logging
#Requires -Module MSOnline

#-----------------------------------------------------------[Parameters]-----------------------------------------------------------

param(
    [CmdletBinding()]
    [string]$Path = "$env:TEMP\Report-MFAStatus.xlsx"
)
#---------------------------------------------------------[Initialisations]--------------------------------------------------------

# Modules
Import-Module -Name Logging
Import-Module -Name MSOnline

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Logging
Set-LoggingDefaultLevel -Level 'DEBUG'
$LogDate = Get-Date -UFormat "%Y-%m-%d@%H-%M-%S"
$LogFile = "$($env:TEMP)\$($MyInvocation.MyCommand.Name) $($LogDate).log"
Add-LoggingTarget -Name Console
Add-LoggingTarget -Name File -Configuration @{
  Path = $LogFile
  Encoding = "UTF8"
}

#-----------------------------------------------------------[Functions]------------------------------------------------------------


#-----------------------------------------------------------[Execution]------------------------------------------------------------

Connect-MsolService
$MSOLUsers = Get-MsolUser -all | Select-Object DisplayName,
UserPrincipalName,
@{
    N="MFA Status"; 
    E={
        if ($_.StrongAuthenticationRequirements.State -ne $null) {
            $_.StrongAuthenticationRequirements.State
        } elseif ( $_.StrongAuthenticationMethods.IsDefault -eq $true) {
            "ConditionalAccess ($(($_.StrongAuthenticationMethods| Where-Object IsDefault -eq $True).MethodType))"
        } else {
            "Disabled"
        }
    }
},
BlockCredential,
IsLicensed,
@{
    N="MFA Default Method Type";
    E={
        ($_.StrongAuthenticationMethods | Where-Object { $_.IsDefault -eq $True}).MethodType
    }
},
@{
    N="MFA MethodType";
    E={
        $_.StrongAuthenticationMethods.MethodType -join ","
    }
}

Export-Excel -Path $Path -InputObject $MSOLUsers -WorksheetName "Users" -AutoSize -AutoFilter -Show

#-----------------------------------------------------------[Finish up]------------------------------------------------------------
Wait-Logging