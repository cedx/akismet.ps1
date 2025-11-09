using namespace System.Diagnostics.CodeAnalysis
using namespace System.Text
using module ./Author.psm1
using module ./Blog.psm1
using module ./CheckResult.psm1
using module ./Client.psm1
using module ./Comment.psm1

<#
.SYNOPSIS
	Creates a new author.
.PARAMETER Name
	The author's name. If you set it to `"viagra-test-123"`, Akismet will always return `$true`.
.PARAMETER IPAddress
	The author's IP address.
.PARAMETER Email
	The author's mail address. If you set it to `"akismet-guaranteed-spam@example.com"`, Akismet will always return `$true`.
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
	[SuppressMessage("PSUseShouldProcessForStateChangingFunctions", "")]
	param (
		[Parameter(Position = 0)]
		[string] $Name = "",

		[Parameter(Mandatory)]
		[ipaddress] $IPAddress,

		[Parameter()]
		[string] $Email = "",

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
	[SuppressMessage("PSUseShouldProcessForStateChangingFunctions", "")]
	param (
		[Parameter(Mandatory, Position = 0)]
		[uri] $Url,

		[Parameter()]
		[ValidateScript(
			{ ($_ -is [Encoding]) -or ($_ -in ([Encoding]::GetEncodings()).ForEach{ $_.GetEncoding().WebName }) },
			ErrorMessage = "The character encoding is invalid."
		)]
		[object] $Charset,

		[ValidateNotNull()]
		[string[]] $Languages = @()
	)

	$blog = [Blog]::new($Url)
	if ($Charset) { $blog.Charset = $Charset -is [Encoding] ? $Charset : [Encoding]::GetEncoding($Charset) }
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
.PARAMETER Uri
	The base URL of the remote API endpoint.
.PARAMETER UserAgent
	The user agent string to use when making requests.
.PARAMETER WhatIf
	Value indicating whether the client operates in test mode.
.OUTPUTS
	The newly created Akismet client.
#>
function New-Client {
	[CmdletBinding()]
	[OutputType([Client])]
	[SuppressMessage("PSUseShouldProcessForStateChangingFunctions", "")]
	[SuppressMessage("PSUseSupportsShouldProcess", "")]
	param (
		[Parameter(Mandatory, Position = 0)]
		[string] $ApiKey,

		[Parameter(Mandatory)]
		[ValidateScript(
			{ ($_ -is [Blog]) -or ($_ -is [string]) -or ($_ -is [uri]) },
			ErrorMessage = "The front page or home URL is invalid."
		)]
		[object] $Blog,

		[ValidateNotNull()]
		[uri] $Uri = "https://rest.akismet.com/",

		[ValidateNotNullOrWhiteSpace()]
		[string] $UserAgent = "PowerShell/$($PSVersionTable.PSVersion) | Akismet/$([Client]::Version)",

		[Parameter()]
		[switch] $WhatIf
	)

	$client = [Client]::new($ApiKey, $Blog -is [Blog] ? $Blog : [Blog]::new($Blog), $Uri)
	$client.IsTest = $WhatIf
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
	[SuppressMessage("PSUseShouldProcessForStateChangingFunctions", "")]
	param (
		[Parameter(Position = 0)]
		[string] $Content = "",

		[Parameter(Mandatory)]
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
	$comment.PostModified = $PostModified
	$comment.RecheckReason = $RecheckReason
	$comment.Referrer = $Referrer
	$comment.Type = $Type
	$comment
}

<#
.SYNOPSIS
	Submits the specified comment that was incorrectly marked as spam but should not have been.
.PARAMETER Client
	The Akismet client used to submit the comment.
.PARAMETER Comment
	The comment to be submitted.
.INPUTS
	The comment to be submitted.
#>
function Submit-Ham {
	[CmdletBinding()]
	[OutputType([void])]
	param (
		[Parameter(Mandatory)]
		[Client] $Client,

		[Parameter(Mandatory, ValueFromPipeline)]
		[Comment] $Comment
	)

	process {
		$Client.SubmitHam($Comment)
	}
}

<#
.SYNOPSIS
	Submits the specified comment that was not marked as spam but should have been.
.PARAMETER Client
	The Akismet client used to submit the comment.
.PARAMETER Comment
	The comment to be submitted.
.INPUTS
	The comment to be submitted.
#>
function Submit-Spam {
	[CmdletBinding()]
	[OutputType([void])]
	param (
		[Parameter(Mandatory)]
		[Client] $Client,

		[Parameter(Mandatory, ValueFromPipeline)]
		[Comment] $Comment
	)

	process {
		$Client.SubmitSpam($Comment)
	}
}

<#
.SYNOPSIS
	Checks the API key against the service database, and returns a value indicating whether it is valid.
.PARAMETER ApiKey
	The Akismet API key.
.PARAMETER Blog
	The front page or home URL of the instance making requests.
.INPUTS
	The Akismet API key.
.OUTPUTS
	`$true` if the specified API key is valid, otherwise `$false`.
#>
function Test-ApiKey {
	[CmdletBinding()]
	[OutputType([bool])]
	param (
		[Parameter(Mandatory, Position = 0, ValueFromPipeline)]
		[string] $ApiKey,

		[Parameter(Mandatory)]
		[ValidateScript(
			{ ($_ -is [Blog]) -or ($_ -is [string]) -or ($_ -is [uri]) },
			ErrorMessage = "The front page or home URL is invalid."
		)]
		[object] $Blog
	)

	process {
		$client = [Client]::new($ApiKey, $Blog -is [Blog] ? $Blog : [Blog]::new($Blog))
		$client.VerifyKey()
	}
}

<#
.SYNOPSIS
	Checks the specified comment against the service database, and returns a value indicating whether it is spam.
.PARAMETER Client
	The Akismet client used to submit the comment.
.PARAMETER Comment
	The comment to be submitted.
.INPUTS
	The comment to be submitted.
.OUTPUTS
	A value indicating whether the specified comment is spam.
#>
function Test-Comment {
	[CmdletBinding()]
	[OutputType([CheckResult])]
	param (
		[Parameter(Mandatory)]
		[Client] $Client,

		[Parameter(Mandatory, ValueFromPipeline)]
		[Comment] $Comment
	)

	process {
		$Client.CheckComment($Comment)
	}
}
