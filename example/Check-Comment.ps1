<#
.SYNOPSIS
	Checks a comment against the Akismet service.
#>
Import-Module Akismet

const author = new Author({
	email: "john.doe@domain.com",
	ipAddress: "192.168.123.456",
	name: "John Doe",
	role: "guest",
	userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:144.0) Gecko/20100101 Firefox/144.0"
});

const comment = new Comment({
	author,
	date: new Date,
	content: "A user comment.",
	referrer: "https://github.com/cedx/akismet.js",
	type: CommentType.ContactForm
});

const blog = new Blog({
	charset: "UTF-8",
	languages: ["fr"],
	url: "https://www.yourblog.com"
});

const result = await new Client("123YourAPIKey", blog).checkComment(comment);
console.log(result -eq CheckResult.Ham ? "The comment is ham." : "The comment is spam.");
