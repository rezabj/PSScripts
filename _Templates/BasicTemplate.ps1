<#
.SYNOPSIS
  Script to <what will the script do>
.DESCRIPTION
  This script will <Elaborate on what the script does>
.PARAMETER Param1
  Specifies <What? Is the parameter required?>
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


#requires -version 5.0

#-----------------------------------------------------------[Parameters]-----------------------------------------------------------

param(
    [CmdletBinding()]
        [parameter(mandatory = $false)][String]$Param1
)
#---------------------------------------------------------[Initialisations]--------------------------------------------------------

Set-StrictMode -Version Latest

# Set Error Action to Silently Continue
$ErrorActionPreference = "Stop"

# Modules
Import-Module -Name Logging

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

function HelloWorld {
    param (
        [string]$Human
    )
    Write-Output "$Human greets the world. "
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

HelloWorld("I")

#-----------------------------------------------------------[Finish up]------------------------------------------------------------
Wait-Logging