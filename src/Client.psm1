using namespace Microsoft.PowerShell.Commands
using namespace System.Net.Http
using module ./Blog.psm1
using module ./CheckResult.psm1
using module ./Comment.psm1

<#
.SYNOPSIS
	Submits comments to the Akismet service.
#>
class Client {

	<#
	.SYNOPSIS
		The response returned by the `submit-ham` and `submit-spam` endpoints when the outcome is a success.
	#>
	hidden static [string] $Success = "Thanks for making the web a better place."

	<#
	.SYNOPSIS
		The package version.
	#>
	hidden static [string] $Version = "6.6.6"

	<#
	.SYNOPSIS
		The Akismet API key.
	#>
	[ValidateNotNullOrWhiteSpace()]
	[string] $ApiKey

	<#
	.SYNOPSIS
		The base URL of the remote API endpoint.
	#>
	[ValidateNotNull()]
	[uri] $BaseUrl

	<#
	.SYNOPSIS
		The front page or home URL of the instance making requests.
	#>
	[ValidateNotNull()]
	[Blog] $Blog

	<#
	.SYNOPSIS
		Value indicating whether the client operates in test mode.
	#>
	[bool] $IsTest = $false

	<#
	.SYNOPSIS
		The user agent string to use when making requests.
	#>
	[string] $UserAgent = "PowerShell/$($PSVersionTable.PSVersion) | Akismet/$([Client]::Version)"

	<#
	.SYNOPSIS
		Creates a new client.
	.PARAMETER ApiKey
		The Akismet API key.
	.PARAMETER Blog
		The front page or home URL of the instance making requests.
	#>
	Client([string] $ApiKey, [Blog] $Blog) {
		$this.ApiKey = $ApiKey
		$this.BaseUrl = "https://rest.akismet.com/"
		$this.Blog = $Blog
	}

	<#
	.SYNOPSIS
		Creates a new client.
	.PARAMETER ApiKey
		The Akismet API key.
	.PARAMETER Blog
		The front page or home URL of the instance making requests.
	.PARAMETER BaseUrl
		The base URL of the remote API endpoint.
	#>
	Client([string] $ApiKey, [Blog] $Blog, [string] $BaseUrl) {
		$this.ApiKey = $ApiKey
		$this.BaseUrl = $BaseUrl.EndsWith("/") ? $BaseUrl : "$BaseUrl/"
		$this.Blog = $Blog
	}

	<#
	.SYNOPSIS
		Checks the specified comment against the service database, and returns a value indicating whether it is spam.
	.PARAMETER Comment
		The comment to be submitted.
	.OUTPUTS
		A value indicating whether the specified comment is spam.
	#>
	[CheckResult] CheckComment([Comment] $Comment) {
		$response = $this.Fetch("1.1/comment-check", $Comment.ToHashtable())
		if ($response.Content -eq "false") { return [CheckResult]::Ham }
		if (-not $response.Headers["X-akismet-pro-tip"]) { return [CheckResult]::Spam }
		return $response.Headers["X-akismet-pro-tip"][0] -eq "discard" ? [CheckResult]::PervasiveSpam : [CheckResult]::Spam
	}

	<#
	.SYNOPSIS
		Submits the specified comment that was incorrectly marked as spam but should not have been.
	.PARAMETER Comment
		The comment to be submitted.
	#>
	[void] SubmitHam([Comment] $Comment) {
		$response = $this.Fetch("1.1/submit-ham", $Comment.ToHashtable())
		if ($response.Content -ne [Client]::Success) { throw [HttpRequestException] "Invalid server response." }
	}

	<#
	.SYNOPSIS
		Submits the specified comment that was not marked as spam but should have been.
	.PARAMETER Comment
		The comment to be submitted.
	#>
	[void] SubmitSpam([Comment] $Comment) {
		$response = $this.Fetch("1.1/submit-spam", $Comment.ToHashtable())
		if ($response.Content -ne [Client]::Success) { throw [HttpRequestException] "Invalid server response." }
	}

	<#
	.SYNOPSIS
		Checks the API key against the service database, and returns a value indicating whether it is valid.
	.OUTPUTS
		`$true` if the specified API key is valid, otherwise `$false`.
	#>
	[bool] VerifyKey() {
		try { return $this.Fetch("1.1/verify-key", @{}).Content -eq "valid" }
		catch { return $false }
	}

	<#
	.SYNOPSIS
		Queries the service by posting the specified fields to a given end point, and returns the response.
	.PARAMETER EndPoint
		The relative URL of the end point to query.
	.PARAMETER Fields
		The fields describing the query body.
	.OUTPUTS
		The server response.
	#>
	hidden [BasicHtmlWebResponseObject] Fetch([string] $EndPoint, [hashtable] $Fields) {
		$body = $this.Blog.ToHashtable()
		$body.api_key = $this.ApiKey
		if ($this.IsTest) { $body.is_test = "1" }
		foreach ($key in $Fields.Keys) { $body.$key = $Fields.$key }

		$response = Invoke-WebRequest ([uri]::new($this.BaseUrl, $EndPoint)) -Method Post -Body $body -UserAgent $this.UserAgent
		if ($response.Headers["X-akismet-alert-msg"]) { throw [HttpRequestException] $response.Headers["X-akismet-alert-msg"][0] }
		if ($response.Headers["X-akismet-debug-help"]) { throw [HttpRequestException] $response.Headers["X-akismet-debug-help"][0] }
		return $response
	}
}
