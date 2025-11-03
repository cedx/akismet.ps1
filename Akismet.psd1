@{
	DefaultCommandPrefix = "Akismet"
	ModuleVersion = "0.1.0"
	PowerShellVersion = "7.4"
	RootModule = "src/Main.psm1"

	Author = "Cédric Belin <cedx@outlook.com>"
	CompanyName = "Cedric-Belin.fr"
	Copyright = "© Cédric Belin"
	Description = "Parse and format to LCOV your code coverage reports."
	GUID = "f986768a-1709-4142-815e-ce3be0db833e"

	AliasesToExport = @()
	CmdletsToExport = @()
	VariablesToExport = @()

	FunctionsToExport = @(

	)

	NestedModules = @(
		"src/Author.psm1"
		"src/Blog.psm1"
		"src/CheckResult.psm1"
		"src/Client.psm1"
		"src/Commen.psm1"
	)

	PrivateData = @{
		PSData = @{
			LicenseUri = "https://github.com/cedx/akismet.ps1/blob/main/License.md"
			ProjectUri = "https://github.com/cedx/akismet.ps1"
			ReleaseNotes = "https://github.com/cedx/akismet.ps1/releases"
			Tags = "akismet", "api", "client", "comment", "spam", "validation"
		}
	}
}
