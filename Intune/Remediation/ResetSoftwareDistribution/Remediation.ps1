if (Test-Path -Path $env:windir\SoftwareDistribution.old) {
    Remove-Item -Path $env:windir\SoftwareDistribution.old -Recurse -Force
}

Stop-Service -Name wuauserv -Force
Move-Item -Path $env:windir\SoftwareDistribution -Destination $env:windir\SoftwareDistribution.old -Force
Start-Service -Name wuauserv

exit 0