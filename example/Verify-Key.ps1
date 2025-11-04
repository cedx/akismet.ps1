<#
.SYNOPSIS
	Verifies an Akismet API key.
#>
Import-Module ../Akismet.psd1

$blog = New-AkismetBlog "https://www.yourblog.com"

const blog = new Blog({url: "https://www.yourblog.com"});
const client = new Client("123YourAPIKey", blog);

const isValid = await client.verifyKey();
console.log(isValid ? "The API key is valid." : "The API key is invalid.");
