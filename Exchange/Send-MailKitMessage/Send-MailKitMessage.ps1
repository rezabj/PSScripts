# Install-package -name 'mimeKit' -Source "https://www.nuget.org/api/v2" -SkipDependencies
# Install-Package -Name 'MailKit' -Source "https://www.nuget.org/api/v2"

Import-Module -Name MSAL.PS

#----------------------------------------------------------[Declarations]----------------------------------------------------------
$ClientID = "a451776a-d3df-4723-bfcd-d7e2f7706662"
$TenantID = "9485d225-8e82-41bb-9ce8-977bb3795c4e"

$User     = "admin@M365x945104.onmicrosoft.com"
$Pass     = "XXXXXXXX"
$SecuredPass = ConvertTo-SecureString -String $Pass -AsPlainText -Force

$Credential = New-Object System.Management.Automation.PSCredential -ArgumentList $User, $SecuredPass

#-----------------------------------------------------------[Functions]------------------------------------------------------------
$Token = Get-MsalToken -ClientId $ClientID -TenantId $TenantID -UserCredential $Credential -Scopes "https://outlook.office.com/SMTP.Send"

#-----------------------------------------------------------[Execution]------------------------------------------------------------
Add-Type -Path 'C:\Program Files\PackageManagement\NuGet\Packages\MimeKit.3.4.1\lib\net6.0\MimeKit.dll'
Add-Type -Path 'C:\Program Files\PackageManagement\NuGet\Packages\MailKit.3.4.1\lib\net6.0\MailKit.dll'

$SMTP = New-Object MailKit.Net.Smtp.SmtpClient
$Message  = New-Object MimeKit.MimeMessage
$OAuth = New-Object MailKit.Security.SaslMechanismOAuth2($User, $Token.AccessToken)

$TextPart = [MimeKit.TextPart]::new("plain")
$TextPart.Text = "Test message"
$Message.From.Add("$user")
$Message.To.Add("Jan.Rezab@mainstream.cz")
$Message.Subject = 'Test subject'
$Message.Body = $TextPart
$SMTP.Connect("smtp.office365.com", 587, $false)
$SMTP.Authenticate($OAuth)
$SMTP.Send($Message)
$SMTP.Disconnect($true)
$SMTP.Dispose()
#-----------------------------------------------------------[Finish up]------------------------------------------------------------
