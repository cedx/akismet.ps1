"Performing the static analysis of source code..."
Import-Module PSScriptAnalyzer
Invoke-ScriptAnalyzer $PSScriptRoot -Recurse
Invoke-ScriptAnalyzer src -Recurse
Invoke-ScriptAnalyzer test -Recurse
Test-ModuleManifest "$PSScriptRoot/../Akismet.psd1" | Out-Null
