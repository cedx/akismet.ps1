<#
.SYNOPSIS
	Tests the features of the `Main` module.
#>
Describe "Main" {
	BeforeAll {
		Import-Module ./Akismet.psd1

		$author = @{
			IPAddress = "192.168.0.1"
			Name = "Akismet"
			Role = "administrator"
			Url = "https://cedric-belin.fr"
			UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:144.0) Gecko/20100101 Firefox/144.0"
		}

		$ham = @{
			Author = New-AkismetAuthor @author
			Content = "I'm testing out the Service API."
			Referrer = "https://www.powershellgallery.com/packages/Akismet"
			Type = "comment"
		}

		$author = @{
			Email = "akismet-guaranteed-spam@example.com"
			IPAddress = "127.0.0.1"
			Name = "viagra-test-123"
			UserAgent = "Spam Bot/6.6.6"
		}

		$spam = @{
			Author = New-AkismetAuthor @author
			Content = "Spam!"
			Date = Get-Date
			Type = "blog-post"
		}

		$client = New-AkismetClient -ApiKey $Env:AKISMET_API_KEY -Blog "https://github.com/cedx/akismet.ps1" -IsTest
		$ham = New-AkismetComment @ham
		$spam = New-AkismetComment @spam
	}

	Context "Submit-Ham" {
		It "should complete without any error" {
			{ $ham | Submit-AkismetHam -Client $client } | Should -Not -Throw
		}
	}

	Context "Submit-Spam" {
		It "should complete without any error" {
			{ $spam | Submit-AkismetSpam -Client $client } | Should -Not -Throw
		}
	}

	Context "Test-ApiKey" {
		It "should return `$true for a valid API key" {
			$client.ApiKey | Test-AkismetApiKey -Blog $client.Blog | Should -BeTrue
		}

		It "should return `$false for an invalid API key" {
			"0123456789-ABCDEF" | Test-AkismetApiKey -Blog $client.Blog | Should -BeFalse
		}
	}

	Context "Test-Comment" {
		It "should return [CheckResult]::Ham for valid comment (e.g. ham)" {
			$ham | Test-AkismetComment -Client $client | Should -Be "Ham"
		}

		It "should return [CheckResult]::Spam for invalid comment (e.g. spam)" {
			$spam | Test-AkismetComment -Client $client | Should -BeIn "Spam", "PervasiveSpam"
		}
	}
}
