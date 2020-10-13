<#
.Synopsis
	Returns the (UTF-16) .NET string for a given Unicode codepoint, which may be a surrogate pair.

.Notes
	An alias of U+ allows you to interpolate a codepoint like this "$(U+ 0x1F5A7) Network"

.Parameter Codepoint
	The integer value of a Unicode codepoint to convert into a .NET string.

.Link
	https://docs.microsoft.com/dotnet/api/system.char.convertfromutf32

.Example
	"$(Get-Unicode 0x1F5A7) Network"

	<three networked computers> Network
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][int] $Codepoint
)
[char]::ConvertFromUtf32($Codepoint)
