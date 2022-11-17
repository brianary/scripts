<#
.SYNOPSIS
Displays a string, showing nonprintable characters.

.INPUTS
System.Object to serialize with nonprintable characters made visible as a hex pair.

.EXAMPLE
Write-VisibleString.ps1 "a`tb`nc"

a 09 b 0a c
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
# The string to show.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][object] $InputObject,
# The color to use for nonprintable chars.
[ConsoleColor] $AltColor = 'DarkYellow',
# Print control characters as control picture symbols rather than hex values.
[switch] $AsSymbols
)
$formatHex = {if([int]$_ -gt 0x100){'{0:X4}' -f [int]$_}else{'{0:X2}' -f [int]$_}}
function Write-Strings([string[]] $String)
{
	if(!$String) {return}
	[char] $c = $String[0][0]
	if(![char]::IsControl($c) -and ![char]::IsWhiteSpace($c) -and
		![char]::IsLowSurrogate($c) -and ![char]::IsHighSurrogate($c))
	{
		Write-Info.ps1 $String[0] -NoNewline
	}
	else
	{
		if($AsSymbols -and ([int]$c) -le 0x20)
		{
			$Local:OFS = ''
			Write-Info.ps1 ([string]($String[0].ToCharArray() |foreach {[char](0x2400+[int]$_)})) `
				-NoNewline -ForegroundColor $AltColor
		}
		else
		{
			Write-Info.ps1 " $($String[0].GetEnumerator() |foreach $formatHex) " `
				-NoNewline -ForegroundColor $AltColor
		}
	}
	if($String.Length -gt 1) {Write-Strings ($String[1..($String.Length-1)])}
	else {Write-Info.ps1}
}
Write-Strings ([convert]::ToString($InputObject) -split '((?:\p{C}+|\p{Z}+))')
