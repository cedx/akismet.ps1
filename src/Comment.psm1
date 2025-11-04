using module ./Author.psm1

<#
.SYNOPSIS
	Represents a comment submitted by an author.
#>
class Comment {

	<#
	.SYNOPSIS
		The comment's author.
	#>
	[ValidateNotNull()]
	[Author] $Author

	<#
	.SYNOPSIS
		The comment's content.
	#>
	[string] $Content

	<#
	.SYNOPSIS
		The context in which this comment was posted.
	#>
	[ValidateNotNull()]
	[string[]] $Context = @()

	<#
	.SYNOPSIS
		The UTC timestamp of the creation of the comment.
	#>
	[Nullable[datetime]] $Date

	<#
	.SYNOPSIS
		The permanent location of the entry the comment is submitted to.
	#>
	[uri] $Permalink

	<#
	.SYNOPSIS
		The UTC timestamp of the publication time for the post, page or thread on which the comment was posted.
	#>
	[Nullable[datetime]] $PostModified

	<#
	.SYNOPSIS
		A string describing why the content is being rechecked.
	#>
	[string] $RecheckReason = ""

	<#
	.SYNOPSIS
		The URL of the webpage that linked to the entry being requested.
	#>
	[uri] $Referrer

	<#
	.SYNOPSIS
		The comment's type.
	#>
	[string] $Type = ""

	<#
	.SYNOPSIS
		Creates a new comment.
	.PARAMETER Author
		The comment's author.
	#>
	Comment([Author] $Author) {
		$this.Author = $Author
		$this.Content = ""
	}

	<#
	.SYNOPSIS
		Creates a new comment.
	.PARAMETER Content
		The comment's content.
	.PARAMETER Author
		The comment's author.
	#>
	Comment([string] $Content, [Author] $Author) {
		$this.Author = $Author
		$this.Content = $Content
	}

	<#
	.SYNOPSIS
		Converts this object into a hashtable.
	.OUTPUTS
		The hashtable corresponding to this object.
	#>
	hidden [hashtable] ToHashtable() {
		$map = $this.Author.ToHashtable()
		if ($this.Content) { $map.comment_content = $this.Content }
		# TODO if ($this.Context) { $map.comment_context = $this.Context -join "," }
		if ($this.Date) { $map.comment_date_gmt = $this.Date.ToUniversalTime().ToString("o") }
		if ($this.Permalink) { $map.permalink = $this.Permalink.ToString() }
		if ($this.PostModified) { $map.comment_post_modified_gmt = $this.PostModified.ToUniversalTime().ToString("o") }
		if ($this.RecheckReason) { $map.recheck_reason = $this.RecheckReason }
		if ($this.Referrer) { $map.referrer = $this.Referrer.ToString() }
		if ($this.Type) { $map.comment_type = $this.Type }
		return $map
	}
}

<#
.SYNOPSIS
	Specifies the type of a comment.
#>
class CommentType {

	<#
	.SYNOPSIS
		A blog post.
	#>
	static [string] $BlogPost = "blog-post"

	<#
	.SYNOPSIS
		A blog comment.
	#>
	static [string] $Comment = "comment"

	<#
	.SYNOPSIS
		A contact form or feedback form submission.
	#>
	static [string] $ContactForm = "contact-form"

	<#
	.SYNOPSIS
		A top-level forum post.
	#>
	static [string] $ForumPost = "forum-post"

	<#
	.SYNOPSIS
		A message sent between just a few users.
	#>
	static [string] $Message = "message"

	<#
	.SYNOPSIS
		A reply to a top-level forum post.
	#>
	static [string] $Reply = "reply"

	<#
	.SYNOPSIS
		A new user account.
	#>
	static [string] $Signup = "signup"
}
