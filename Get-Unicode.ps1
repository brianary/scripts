<#
.SYNOPSIS
Returns the (UTF-16) .NET string for a given Unicode codepoint, which may be a surrogate pair.

.NOTES
An alias of U+ allows you to interpolate a codepoint like this "$(U+ 0x1F5A7) Network"

This script is mostly useful to Windows PowerShell (before version 6), since PowerShell Core
supports the new `u{1F5A5} syntax.

.INPUTS
System.Int32 value of a Unicode codepoint.

.OUTPUTS
System.String of Unicode character(s) identified by codepoints.

.FUNCTIONALITY
Unicode

.LINK
https://docs.microsoft.com/dotnet/api/system.char.convertfromutf32

.LINK
https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_special_characters#unicode-character-ux

.LINK
https://emojipedia.org/variation-selector-16/

.EXAMPLE
"$(Get-Unicode 0x1F5A7) Network"

<three networked computers> Network
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
# The integer value of a Unicode codepoint to convert into a .NET string.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][int] $Codepoint,
<#
Appends a U+FE0F VARIATION SELECTOR-16 suffix to the character, which suggests an emoji presentation
for characters that support both a simple text presentation as well as a color emoji-style one.
#>
[switch] $AsEmoji,
# Outputs the codepoint as a usable PowerShell string literal.
[switch] $AsStringLiteral
)
Begin { [char[]] $c = @() }
Process
{
	[char]::ConvertFromUtf32($Codepoint).GetEnumerator() |ForEach-Object {$c += $_}
	if($AsEmoji) {$c += 0xFE0F}
}
End
{
	$s = New-Object string (,$c)
	if(!$AsStringLiteral) {$s}
	else {$Local:OFS='';"`"$($s.GetEnumerator() |ForEach-Object {'$([char]0x{0:X4})' -f [int]$_})`""}
}

