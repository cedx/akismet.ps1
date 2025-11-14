<#
.SYNOPSIS
	Specifies the result of a comment check.
#>
enum CheckResult {

	<#
	.SYNOPSIS
		The comment is a ham.
	#>
	Ham

	<#
	.SYNOPSIS
		The comment is a spam.
	#>
	Spam

	<#
	.SYNOPSIS
		The comment is a pervasive spam (i.e. it can be safely discarded).
	#>
	PervasiveSpam
}
