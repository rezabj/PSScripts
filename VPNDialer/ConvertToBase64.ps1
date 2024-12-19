$Content = get-content .\VPNDial.ps1

$base64Cmd = [System.Convert]::ToBase64String(
  [System.Text.Encoding]::Unicode.GetBytes($Content)
)

Write-Output $base64Cmd