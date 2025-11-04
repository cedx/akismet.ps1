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
.PARAMETER ApiKey
	The Akismet API key.
.PARAMETER Blog
	The front page or home URL of the instance making requests.
.PARAMETER IsTest
	Value indicating whether the client operates in test mode.
.PARAMETER Uri
	The base URL of the remote API endpoint.
.OUTPUTS
	The newly created Akismet client.
#>
function New-Client {
	[CmdletBinding()]
	[OutputType([Client])]
	param (
		[Parameter(Mandatory, Position = 0)]
		[ValidateNotNullOrWhiteSpace()]
		[string] $ApiKey,

		[Parameter(Mandatory, Position = 1)]
		[ValidateNotNull()]
		[Blog] $Blog,

		[Parameter()]
		[bool] $IsTest = $false,

		[ValidateNotNull()]
		[uri] $Uri = "https://rest.akismet.com/",

		[ValidateNotNullOrWhiteSpace()]
		[string] $UserAgent = "PowerShell/$($PSVersionTable.PSVersion) | Akismet/$([Client]::Version)"
	)

	$client = [Client]::new($ApiKey, $Blog, $Uri)
	$client.IsTest = $IsTest
	$client.UserAgent = $UserAgent
	$client
}

<#
.SYNOPSIS
	Creates a new comment.
.PARAMETER Content
	The comment's content.
.PARAMETER Author
	The comment's author.
.PARAMETER Context
	The context in which this comment was posted.
.PARAMETER Date
	The UTC timestamp of the creation of the comment.
.PARAMETER Permalink
	The permanent location of the entry the comment is submitted to.
.PARAMETER PostModified
	The UTC timestamp of the publication time for the post, page or thread on which the comment was posted.
.PARAMETER RecheckReason
	A string describing why the content is being rechecked.
.PARAMETER Referrer
	The URL of the webpage that linked to the entry being requested.
.PARAMETER Type
	The comment's type.
.OUTPUTS
	The newly created comment.
#>
function New-Comment {
	[CmdletBinding()]
	[OutputType([Comment])]
	param (
		[Parameter(Position = 0)]
		[string] $Content = "",

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[Author] $Author,

		[ValidateNotNull()]
		[string[]] $Context = @(),

		[Parameter()]
		[Nullable[datetime]] $Date,

		[Parameter()]
		[uri] $Permalink,

		[Parameter()]
		[Nullable[datetime]] $PostModified,

		[Parameter()]
		[string] $RecheckReason = "",

		[Parameter()]
		[uri] $Referrer,

		[Parameter()]
		[string] $Type = ""
	)

	$comment = [Comment]::new($Content, $Author)
	$comment.Context = $Context
	$comment.Date = $Date
	$comment.Permalink = $Permalink
	$comment.PostModified = $ToDo
	$comment.RecheckReason = $RecheckReason
	$comment.Referrer = $Referrer
	$comment.Type = $Type
	$comment
}
