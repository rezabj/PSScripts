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

$O365AdminAccount   = "admin@contoso.com"
$O365AdminPassword  = "Passw0rd"

$secpasswd = ConvertTo-SecureString -String $O365AdminPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($O365AdminAccount, $secpasswd)

$exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $credential -Authentication "Basic" -AllowRedirection -WarningAction SilentlyContinue -InformationAction SilentlyContinue
Import-PSSession $exchangeSession -DisableNameChecking -AllowClobber

$mailboxes = Get-Mailbox -ResultSize unlimited -RecipientTypeDetails UserMailbox

foreach ($mailbox in $mailboxes) {
    $calendarfolder = Get-MailboxFolderStatistics -Identity $mailbox.userPrincipalName -FolderScope calendar | where-object {$_.FolderType -eq "Calendar"}
    $calendarfolderpath = "$($mailbox.UserPrincipalName):\$($calendarfolder.FolderPath.Trim("/"))"
    
    switch ( $mailbox.UserPrincipalName ) {
        # Specifi perm for any users
        'User1@contoso.com'     { Set-MailboxFolderPermission -Identity $calendarfolderpath -User Default -AccessRights AvailabilityOnly -WarningAction SilentlyContinue }
        'User2@contoso.com' { Set-MailboxFolderPermission -Identity $calendarfolderpath -User Default -AccessRights AvailabilityOnly -WarningAction SilentlyContinue }
        'User3@contoso.com'         { Set-MailboxFolderPermission -Identity $calendarfolderpath -User Default -AccessRights AvailabilityOnly -WarningAction SilentlyContinue }
        # Specifi perm for all other users.
        Default                    { Set-MailboxFolderPermission -Identity $calendarfolderpath -User Default -AccessRights LimitedDetails -WarningAction SilentlyContinue }
        }
     Write-Output $calendarfolderpath
     Start-Sleep -m 50
}