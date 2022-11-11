$params = @{
  Subject = 'CN=Jan Řežab PowerShell Code Signing Cert'
  Type = 'CodeSigning'
  CertStoreLocation = 'Cert:\CurrentUser\My'
  HashAlgorithm = 'sha256'
}
New-SelfSignedCertificate @params