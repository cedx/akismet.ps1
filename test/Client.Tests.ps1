using namespace System.Diagnostics.CodeAnalysis
using module ../src/Author.psm1
using module ../src/Blog.psm1
using module ../src/Client.psm1
using module ../src/CheckResult.psm1
using module ../src/Comment.psm1

<#
.SYNOPSIS
	Tests the features of the `Client` module.
#>
Describe "Client" {
	BeforeAll {
		$client = [Client]::new($Env:AKISMET_API_KEY, [Blog]::new("https://github.com/cedx/akismet.ps1"))
		$client.IsTest = $true

		$hamAuthor = [Author]::new("192.168.0.1")
		$hamAuthor.Name = "Akismet"
		$hamAuthor.Role = [AuthorRole]::Administrator
		$hamAuthor.Url = "https://cedric-belin.fr"
		$hamAuthor.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:144.0) Gecko/20100101 Firefox/144.0"

		$ham = [Comment]::new($hamAuthor)
		$ham.Content = "I'm testing out the Service API."
		$ham.Referrer = "https://www.powershellgallery.com/packages/Akismet"
		$ham.Type = [CommentType]::Comment

		$spamAuthor = [Author]::new("127.0.0.1")
		$spamAuthor.Email = "akismet-guaranteed-spam@example.com"
		$spamAuthor.Name = "viagra-test-123"
		$spamAuthor.UserAgent = "Spam Bot/6.6.6"

		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
		$spam = [Comment]::new($spamAuthor)
		$ham.Content = "Spam!"
		$ham.Date = Get-Date
		$ham.Type = [CommentType]::BlogPost
	}

	Context "CheckComment" {
		It "should return [CheckResult]::Ham for valid comment (e.g. ham)" {
			$client.CheckComment($ham) | Should -Be ([CheckResult]::Ham)
		}

		It "should return [CheckResult]::Spam for invalid comment (e.g. spam)" {
			$client.CheckComment($spam) | Should -BeIn @([CheckResult]::Spam, [CheckResult]::PervasiveSpam)
		}
	}

	Context "SubmitHam" {
		It "should complete without any error" {
			{ $client.SubmitHam($ham) } | Should -Not -Throw
		}
	}

	Context "SubmitSpam" {
		It "should complete without any error" {
			{ $client.SubmitSpam($spam) } | Should -Not -Throw
		}
	}

	Context "VerifyKey" {
		It "should return `$true for a valid API key" {
			$client.VerifyKey() | Should -BeTrue
		}

		It "should return `$false for an invalid API key" {
			$newClient = [Client]::new("0123456789-ABCDEF", $client.Blog)
			$newClient.IsTest = $true
			$newClient.VerifyKey() | Should -BeFalse
		}
	}
}
