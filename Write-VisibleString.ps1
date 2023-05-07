<#
.SYNOPSIS
Displays a string, showing nonprintable characters.

.INPUTS
System.Object to serialize with nonprintable characters made visible as a hex pair.

.EXAMPLE
Write-VisibleString.ps1 "a`tb`nc"

a 09 b 0A c
(Formatting is not displayed in help.)
#>

#Requires -Version 7
[CmdletBinding()][OutputType([void])] Param(
# The string to show.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][object] $InputObject,
# Parse Runes from the string rather than Chars.
[switch] $AsRunes,
# Print control characters as control picture symbols rather than hex values.
[switch] $UseSymbols
)
Begin
{
	$symbolStart = $PSStyle.Reverse
	$symbolEnd = $PSStyle.ReverseOff
	$shortHexStart = '{0} {1}{2}' -f $PSStyle.Hidden,$PSStyle.HiddenOff,$PSStyle.Reverse
	$shortHexEnd = '{0}{1} {2}' -f $PSStyle.ReverseOff,$PSStyle.Hidden,$PSStyle.HiddenOff
	$longHexStart = '{0} {1}{2}{3}' -f $PSStyle.Hidden,$PSStyle.HiddenOff,$PSStyle.Reverse,$PSStyle.Bold
	$longHexEnd = '{0}{1}{2} {3}' -f $PSStyle.BoldOff,$PSStyle.ReverseOff,$PSStyle.Hidden,$PSStyle.HiddenOff
	filter Write-Char([Parameter(ValueFromPipeline)][int] $Value)
	{
		if(![char]::IsControl($Value) -and ![char]::IsWhiteSpace($Value) -and
			![char]::IsLowSurrogate($Value) -and ![char]::IsHighSurrogate($Value))
		{
			return [char]$Value
		}
		elseif($UseSymbols -and $Value -le 0x20)
		{
			return '{0}{1}{2}' -f $symbolStart,[char](0x2400+$Value),$symbolEnd
		}
		elseif($Value -ge 0x100)
		{
			return '{0}{1:X4}{2}' -f $longHexStart,$Value,$longHexEnd
		}
		else
		{
			return '{0}{1:X2}{2}' -f $shortHexStart,$Value,$shortHexEnd
		}
	}
	filter Write-Rune([Parameter(ValueFromPipelineByPropertyName)][int] $Value,
		[Parameter(ValueFromPipelineByPropertyName)][bool] $IsAscii,
		[Parameter(ValueFromPipelineByPropertyName)][bool] $IsBmp)
	{
		if($IsAscii -and ![char]::IsControl($Value) -and ![char]::IsWhiteSpace($Value))
		{
			return [char]$Value
		}
		elseif($UseSymbols -and $Value -le 0x20)
		{
			return '{0}{1}{2}' -f $symbolStart,[char](0x2400+$Value),$symbolEnd
		}
		elseif($Value -ge 0x100)
		{
			return '{0}{1:X4}{2}' -f $longHexStart,$Value,$longHexEnd
		}
		else
		{
			return '{0}{1:X2}{2}' -f $shortHexStart,$Value,$shortHexEnd
		}
	}
}
Process
{
	if($AsRunes) {[convert]::ToString($InputObject).EnumerateRunes() |Write-Rune |Out-String -NoNewline |Write-Info.ps1}
	else {[convert]::ToString($InputObject).ToCharArray() |Write-Char |Out-String -NoNewline |Write-Info.ps1}
}
