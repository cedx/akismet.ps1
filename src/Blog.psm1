using namespace System.Text

<#
.SYNOPSIS
	Represents the front page or home URL transmitted when making requests.
#>
class Blog {

	<#
	.SYNOPSIS
		The character encoding for the values included in comments.
	#>
	[Encoding] $Charset = $null

	<#
	.SYNOPSIS
		The languages in use on the blog or site, in ISO 639-1 format.
	#>
	[string[]] $Languages = @()

	<#
	.SYNOPSIS
		The blog or site URL.
	#>
	[ValidateNotNull()]
	[uri] $Url

	<#
	.SYNOPSIS
		Creates a new blog.
	.PARAMETER Url
		The blog or site URL.
	#>
	Blog([uri] $Url) {
		$this.Url = $Url
	}

	<#
	.SYNOPSIS
		Converts this object into a hashtable.
	.OUTPUTS
		The hashtable corresponding to this object.
	#>
	hidden [hashtable] ToHashtable() {
		$map = @{ blog = $this.Url.ToString() }
		if ($this.Charset) { $map.blog_charset = $this.Charset.WebName }
		if ($this.Languages) { $map.blog_lang = $this.Languages -join "," }
		return $map
	}
}
