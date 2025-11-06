using namespace System.Globalization
using module ../src/Author.psm1
using module ../src/Comment.psm1

<#
.SYNOPSIS
	Tests the features of the `Comment` module.
#>
Describe "Comment" {
	Context "ToHashtable" {
		It "should return only the author info with a newly created instance" {
			$map = [Comment]::new([Author]::new("127.0.0.1")).ToHashtable()
			$map.Keys | Should -HaveCount 1
			$map.user_ip | Should -Be "127.0.0.1"
		}

		It "should return a non-empty map with an initialized instance" {
			$author = [Author]::new("Cédric Belin", "192.168.0.1")
			$author.UserAgent = "Doom/6.6.6"

			$comment = [Comment]::new("A user comment.", $author)
			$comment.Date = [datetime]::Parse("2000-01-01T00:00:00Z", [cultureinfo]::InvariantCulture, [DateTimeStyles]::RoundtripKind)
			$comment.Referrer = "https://cedric-belin.fr"
			$comment.Type = [CommentType]::BlogPost

			$map = $comment.ToHashtable()
			$map.Keys | Should -HaveCount 7
			$map.comment_author | Should -BeExactly "Cédric Belin"
			$map.comment_content | Should -BeExactly "A user comment."
			$map.comment_date_gmt | Should -BeExactly "2000-01-01T00:00:00.0000000Z"
			$map.comment_type | Should -BeExactly "blog-post"
			$map.referrer | Should -BeExactly "https://cedric-belin.fr/"
			$map.user_agent | Should -BeExactly "Doom/6.6.6"
			$map.user_ip | Should -Be "192.168.0.1"
		}
	}
}
