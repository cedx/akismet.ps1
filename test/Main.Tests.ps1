<#
.SYNOPSIS
	Tests the features of the `Main` module.
#>
Describe "Main" {
	BeforeAll {
		Import-Module ./Akismet.psd1

		$client = New-AkismetClient -ApiKey $Env:AKISMET_API_KEY -Blog "https://github.com/cedx/akismet.ps1" -IsTest

		# $hamAuthor = New-AkismetAuthor -Name "Akismet" -IPAddress "192.168.0.1"
		# $hamAuthor.Role = [AuthorRole]::Administrator
		# $hamAuthor.Url = "https://cedric-belin.fr"
		# $hamAuthor.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:144.0) Gecko/20100101 Firefox/144.0"

		# $ham = [Comment]::new($hamAuthor)
		# $ham.Content = "I'm testing out the Service API."
		# $ham.Referrer = "https://www.powershellgallery.com/packages/Akismet"
		# $ham.Type = [CommentType]::Comment

		# $spamAuthor = [Author]::new("viagra-test-123", "127.0.0.1")
		# $spamAuthor.Email = "akismet-guaranteed-spam@example.com"
		# $spamAuthor.UserAgent = "Spam Bot/6.6.6"

		# [SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
		# $spam = [Comment]::new($spamAuthor)
		# $ham.Content = "Spam!"
		# $ham.Date = Get-Date
		# $ham.Type = [CommentType]::BlogPost
	}

	Context "Test-Key" {
		It "should return `$true for a valid API key" {
			$client.ApiKey | Test-AkismetKey -Blog $client.Blog | Should -BeTrue
		}

		It "should return `$false for an invalid API key" {
			"0123456789-ABCDEF" | Test-AkismetKey -Blog $client.Blog | Should -BeFalse
		}
	}
}
