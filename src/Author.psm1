<#
.SYNOPSIS
	Represents the author of a comment.
#>
class Author {

	<#
	.SYNOPSIS
		The author's mail address.
		If you set it to `"akismet-guaranteed-spam@example.com"`, Akismet will always return `$true`.
	#>
	[string] $Email = ""

	<#
	.SYNOPSIS
		The author's IP address.
	#>
	[ValidateNotNull()]
	[ipaddress] $IPAddress

	<#
	.SYNOPSIS
		The author's name.
		If you set it to `"viagra-test-123"`, Akismet will always return `$true`.
	#>
	[string] $Name = ""

	<#
	.SYNOPSIS
		The author's role.
		If you set it to `"administrator"`, Akismet will always return `$false`.
	#>
	[string] $Role = ""

	<#
	.SYNOPSIS
		The URL of the author's website.
	#>
	[uri] $Url = $null

	<#
	.SYNOPSIS
		The author's user agent, that is the string identifying the Web browser used to submit comments.
	#>
	[string] $UserAgent = ""

	<#
	.SYNOPSIS
		Creates a new author.
	.PARAMETER IPAddress
		The author's IP address.
	#>
	Author([ipaddress] $IPAddress) {
		$this.IPAddress = $IPAddress
	}

	<#
	.SYNOPSIS
		Converts this object into a hashtable.
	.OUTPUTS
		The hashtable corresponding to this object.
	#>
	hidden [hashtable] ToHashtable() {
		$map = @{ user_ip = $this.IPAddress.ToString() }
		if ($this.Email) { $map.comment_author_email = $this.Email }
		if ($this.Name) { $map.comment_author = $this.Name }
		if ($this.Role) { $map.user_role = $this.Role }
		if ($this.Url) { $map.comment_author_url = $this.Url.ToString() }
		if ($this.UserAgent) { $map.user_agent = $this.UserAgent }
		return $map
	}
}

<#
.SYNOPSIS
	Specifies the role of an author.
#>
class AuthorRole {

	<#
	.SYNOPSIS
		The author is an administrator.
	#>
	static [string] $Administrator = "administrator"
}
