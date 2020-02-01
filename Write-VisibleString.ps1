<#
.Synopsis
	Displays a string, showing nonprintable characters.

.Parameter InputObject
	The string to show.

.Parameter AltColor
	The color to use for nonprintable chars.

.Parameter AsSymbols
	Print control characters as control picture symbols rather than hex values.

.Example
	Write-VisibleString.ps1 "a`tb`nc"

	a 09 b 0a c
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][object] $InputObject,
[ConsoleColor] $AltColor = 'DarkYellow',
[switch] $AsSymbols
)
function Write-Strings([string[]] $String)
{
	if(![char]::IsControl($String[0][0])) {Write-Host $String[0] -NoNewline}
	else
	{
		if($AsSymbols) {Write-Host ([string]($String[0].ToCharArray() |foreach {[char](0x2400+[int]$_)})) -NoNewline -ForegroundColor $AltColor}
		else {Write-Host (' '+(($String[0].ToCharArray() |foreach {'{0:X2} ' -f [int]$_}) -join ' ')) -NoNewline -ForegroundColor $AltColor}
	}
	if($String.Length -gt 1) {Write-Strings ($String[1..($String.Length-1)])}
	else {Write-Host}
}
Write-Strings ([convert]::ToString($InputObject) -split '(\p{Cc}+)')
