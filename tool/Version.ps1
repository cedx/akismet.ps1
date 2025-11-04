"Updating the version number in the sources..."
$version = (Import-PowerShellDataFile "Akismet.psd1").ModuleVersion
(Get-Content "src/Client.psm1") -replace 'Version = "\d+(\.\d+){2}"', "Version = ""$version""" | Out-File "src/Client.psm1"
(Get-Content "ReadMe.md") -replace "module/v\d+(\.\d+){2}", "module/v$version" | Out-File "ReadMe.md"
