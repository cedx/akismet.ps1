using module ../src/Author.psm1

<#
.SYNOPSIS
	Tests the features of the `Author` module.
#>
Describe "Author" {
	Context "ToHashtable" {
		It "should return only the IP address with a newly created instance" {
			$map = [Author]::new("127.0.0.1").ToHashtable()
			$map.Keys | Should -HaveCount 1
			$map.user_ip | Should -Be "127.0.0.1"
		}

		It "should return a non-empty map with an initialized instance" {
			$author = [Author]::new("Cédric Belin", "192.168.0.1")
			$author.Email = "contact@cedric-belin.fr"
			$author.Url = "https://cedric-belin.fr"
			$author.UserAgent = "Mozilla/5.0"

			$map = $author.ToHashtable()
			$map.Keys | Should -HaveCount 5
			$map.comment_author | Should -BeExactly "Cédric Belin"
			$map.comment_author_email | Should -BeExactly "contact@cedric-belin.fr"
			$map.comment_author_url | Should -BeExactly "https://cedric-belin.fr/"
			$map.user_agent | Should -BeExactly "Mozilla/5.0"
			$map.user_ip | Should -Be "192.168.0.1"
		}
	}
}
