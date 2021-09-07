<#
.Synopsis
	Returns the (UTF-16) .NET string for a given Unicode codepoint, which may be a surrogate pair.

.Notes
	An alias of U+ allows you to interpolate a codepoint like this "$(U+ 0x1F5A7) Network"
	
	This script is mostly useful to Windows PowerShell (before version 6), since PowerShell Core
	supports the new `u{1F5A5} syntax.

.Parameter Codepoint
	The integer value of a Unicode codepoint to convert into a .NET string.
	
.Parameter AsEmoji
	Adds a U+FE0F VARIATION SELECTOR-16 suffix to the character, which suggests an emoji presentation
	for characters that support a simple text presentation as well as a color emoji-style one.
	
.Inputs
	System.Int32 value of a Unicode codepoint.
	
.Outputs
	System.String of Unicode character(s) identified by codepoints.

.Link
	https://docs.microsoft.com/dotnet/api/system.char.convertfromutf32
	
.Link
	https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_special_characters#unicode-character-ux
	
.Link
	https://emojipedia.org/variation-selector-16/

.Example
	"$(Get-Unicode 0x1F5A7) Network"

	<three networked computers> Network
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][int] $Codepoint,
[switch] $AsEmoji
)
Begin { [char[]] $c = @() }
Process
{
	[char]::ConvertFromUtf32($Codepoint).GetEnumerator() |foreach {$c += $_}
	if($AsEmoji) {$c += 0xFE0F}
}
End { New-Object string (,$c) }
