using module ./Author.psm1
using module ./Blog.psm1
using module ./CheckResult.psm1
using module ./Client.psm1
using module ./Comment.psm1

<#
.SYNOPSIS
	Creates a new author.
.PARAMETER IPAddress
	The author's IP address.
.PARAMETER Email
	The author's mail address. If you set it to `"akismet-guaranteed-spam@example.com"`, Akismet will always return `$true`.
.PARAMETER Name
	The author's name. If you set it to `"viagra-test-123"`, Akismet will always return `$true`.
.PARAMETER Role
	The author's role. If you set it to `"administrator"`, Akismet will always return `$false`.
.PARAMETER Url
	The URL of the author's website.
.PARAMETER UserAgent
	The author's user agent, that is the string identifying the Web browser used to submit comments.
.OUTPUTS
	The newly created author.
#>
function New-Author {
	[CmdletBinding()]
	[OutputType([Author])]
	param (
		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[ipaddress] $IPAddress,

		[Parameter()]
		[string] $Email = "",

		[Parameter(Position = 0)]
		[string] $Name = "",

		[Parameter()]
		[string] $Role = "",

		[Parameter()]
		[uri] $Url,

		[Parameter()]
		[string] $UserAgent = ""
	)

	$author = [Author]::new($Name, $IPAddress)
	$author.Email = $Email
	$author.Role = $Role
	$author.Url = $Url
	$author.UserAgent = $UserAgent
	$author
}

<#
.SYNOPSIS
	Creates a new blog.
.PARAMETER Url
	The blog or site URL.
.PARAMETER Charset
	The character encoding for the values included in comments.
.PARAMETER Languages
	The languages in use on the blog or site, in ISO 639-1 format.
.OUTPUTS
	The newly created blog.
#>
function New-Blog {
	[CmdletBinding()]
	[OutputType([Blog])]
	param (
		[Parameter(Mandatory, Position = 0)]
		[ValidateNotNull()]
		[uri] $Url,

		[Parameter()]
		[Encoding] $Charset,

		[ValidateNotNull()]
		[string[]] $Languages = @()
	)

	$blog = [Blog]::new($Url)
	$blog.Charset = $Charset
	$blog.Languages = $Languages
	$blog
}

<#
.SYNOPSIS
	Creates a new Akismet client.
.PARAMETER Uri
	The base URL of the remote API endpoint.
.OUTPUTS
	The newly created Akismet client.
#>
function New-Client {
	[CmdletBinding()]
	[OutputType([Client])]
	param (

		[ValidateNotNull()]
		[uri] $Uri = "https://rest.akismet.com/"
	)
}

<#
.SYNOPSIS
	Creates a new comment.
.OUTPUTS
	The newly created comment.
#>
function New-Comment {
	[CmdletBinding()]
	[OutputType([Comment])]
	param (

	)

	$comment = [Comment]::new($Author)
	$comment.ToDo = $ToDo
	$comment
}
