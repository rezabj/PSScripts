# Get all folders in F:\Home
$AllUserFolders = Get-ChildItem -Path "F:\Home" -Directory

# Main loop
foreach ($UserFolder in $AllUserFolders) {

    # Get all subfolders from user folder
    $ChildFolders = Get-ChildItem -Path $UserFolder.FullName -Directory -Recurse
    
    # Backup all ACLs to variable $ACLs
    $ACLs = @()

    # For each subfolder in user folder
    foreach ($ChildFolder in $ChildFolders) {
      
      # Get subfolder ACLs and backup them to variable $ACLs
      $Permission = Get-Acl -Path $ChildFolder.FullName
      $ACLs += $Permission

      # Enable inheritance
      $Permission.SetAccessRuleProtection($False,$true)
      Set-Acl -Path $ChildFolder.FullName -AclObject $Permission

      # Get subfolder ACLs and remove all non-inherited permissions
      $Perm = Get-Acl -Path $ChildFolder.FullName
      $Perm.Access | Where-Object { $_.IsInherited -eq $False } | ForEach-Object {
        $Perm.RemoveAccessRule($_)
      }
      Set-Acl -Path $ChildFolder.FullName -AclObject $Perm
    }

    # Export previous ACLs to XML file
    Export-Clixml -InputObject $ACLs -Path "C:\ACLs\$($UserFolder.Name).xml"
}