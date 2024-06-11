<#
.SYNOPSIS
  Script generate MFA Report.
.DESCRIPTION
  This script will generate excel report for users MFA status.
.INPUTS
  <Does the script accept an input>
.OUTPUTS
  A log file in the temp directory of the user running the script
.NOTES
  Version:        1.
  Author:         Jan Řežab
  Creation Date:  <Date>
  Purpose/Change: Initial script development
#>

#Requires -version 5.0

#Requires -Module Microsoft.Graph.Users
#Requires -Module Microsoft.Graph.Authentication

#Region [Configuration]
Import-Module -Name Microsoft.Graph.Users -ErrorAction Stop
Import-Module -Name Microsoft.Graph.Authentication -ErrorAction Stop
#EndRegion

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.Read.All","UserAuthenticationMethod.Read.All" -ErrorAction Stop

# Get all users
$Users = Get-MgUser -All -ErrorAction Stop

$Report = @()

# Get all users MFA status
foreach ($User in $Users) {
  Remove-Variable -Name AuthMethods -ErrorAction SilentlyContinue

  $AuthMethods = Get-MgUserAuthenticationMethod -UserId $User.Id -ErrorAction SilentlyContinue

  if($AuthMethods) {
    foreach ($AuthMethod in $AuthMethods) {
      $Report += [PSCustomObject]@{
        UserID     = $User.Id
        UserUPN    = $User.UserPrincipalName
        MFAID      = $AuthMethod.Id
        MFAType    = $AuthMethod.AdditionalProperties["@odata.type"]
        MFACreated = $AuthMethod.AdditionalProperties["createdDateTime"]
        MFADetail  = $AuthMethod.AdditionalProperties | ConvertTo-Json -Compress
      }
    }
  } else {
    $Report += [PSCustomObject]@{
      UserID     = $User.Id
      UserUPN    = $User.UserPrincipalName
      MFAID      = "N/A"
      MFAType    = "N/A"
      MFACreated = "N/A"
      MFADetail  = "N/A"
    }
  }
}

$Report | Export-Csv -Path "C:\Help\MFAReport.csv" -Delimiter ";" -Encoding utf8 -NoTypeInformation -ErrorAction Stop