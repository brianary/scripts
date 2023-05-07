<#
.SYNOPSIS
Displays the HTTP status code info.

.FUNCTIONALITY
HTTP

.EXAMPLE
Show-HttpStatus.ps1 ServiceUnavailable -AsCat

.EXAMPLE
Show-HttpStatus.ps1 200 -AsCat
#>

#Requires -Version 3
[CmdletBinding()] Param(
# The HTTP status code to describe.
[Parameter(Position=0,Mandatory=$true)][Net.HttpStatusCode] $Status,
# Render the code as a cat.
[switch] $AsCat
)
Begin
{
	if($AsCat -and !(Get-Command Out-ConsolePicture -ErrorAction Ignore))
	{
		Install-Module OutConsolePicture
	}
}
Process
{
	"$([int]$Status) $Status"
	"https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/$([int]$Status)"
	if($AsCat)
	{
		$cat = "https://http.cat/$([int]$Status)"
		Out-ConsolePicture -Url $cat
		$cat
	}
}

