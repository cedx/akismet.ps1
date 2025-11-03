using namespace System.Text
using module ../src/Blog.psm1

<#
.SYNOPSIS
	Tests the features of the `Blog` module.
#>
Describe "Blog" {
	Context "ToHashtable" {
		It "should return only the blog URL with a newly created instance" {
			$map = [Blog]::new("https://github.com/cedx/akismet.ps1").ToHashtable()
			$map.Keys | Should -HaveCount 1
			$map.blog | Should -BeExactly "https://github.com/cedx/akismet.ps1"
		}

		It "should return a non-empty map with an initialized instance" {
			$blog = [Blog]::new("https://github.com/cedx/akismet.ps1")
			$blog.Charset = [Encoding]::UTF8
			$blog.Languages = "en", "fr"

			$map = $blog.ToHashtable()
			$map.Keys | Should -HaveCount 3
			$map.blog | Should -BeExactly "https://github.com/cedx/akismet.ps1"
			$map.blog_charset | Should -BeExactly "utf-8"
			$map.blog_lang | Should -BeExactly "en,fr"
		}
	}
}
