<#
.SYNOPSIS
Determines the indent characters used in a text file.

.PARAMETER Path
The location of a file.

.INPUTS
Any object with a Path or FullName property to use for a file location.

.OUTPUTS
System.Management.Automation.PSCustomObject with the following properties:

* Path, a string containing the location of the file.
* Indents, one of: Tabs, Spaces, Mixed, Other, or None.
* HT, a count of the lines indented with tabs.
* SP, a count of the lines indented with spaces.
* MixedIndents, a count of the lines indented with multiple types of space characters.
* OtherIndents, a count of the lines indented with a space character other than tab or space.

.LINK
Select-String

.EXAMPLE
Get-FileIndentCharacter.ps1 Get-FileIndentCharacter.ps1

Path         : A:\scripts\Get-FileIndentCharacter.ps1
Indents      : Tabs
HT           : 40
SP           : 0
MixedIndents : 0
OtherIndents : 0
#>

#Requires -Version 3
[CmdletBinding()][OutputType([psobject])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true,ValueFromRemainingArguments=$true)]
[Alias('FullName')][string] $Path
)
Begin
{
	Set-Variable HT ([char]0x9) -Option Constant
	Set-Variable SP ([char]0x20) -Option Constant
}
Process
{
	foreach($file in (Resolve-Path $Path).Path)
	{
		$countTab,$countSpace,$countMixed,$countOther = 0,0,0,0
		foreach($indent in Select-String '^(\s+)' $file |foreach {$_.Matches.Groups[0].Value})
		{
			if($indent.Trim(@($HT)) -eq '') {$countTab++}
			elseif($indent.Trim(@($SP)) -eq '') {$countSpace++}
			elseif(($indent.GetEnumerator() |select -Unique).Count -gt 1) {$countMixed++}
			else {$countOther++}
		}
		Write-Verbose "Indent counts: HT=$countTab, SP=$countSpace, other/combined=$countOther"
		$indents =
			if($countMixed) {'Mixed'}
			elseif($countTab) { if($countSpace -or $countOther) {'Mixed'} else {'Tabs'} }
			elseif($countSpace) { if($countOther) {'Mixed'} else {'Spaces'} }
			elseif($countOther) {'Other'}
			else {'None'}
		[pscustomobject]@{
			Path         = $file
			Indents      = $indents
			HT           = $countTab
			SP           = $countSpace
			MixedIndents = $countMixed
			OtherIndents = $countOther
		} |Add-Member ScriptMethod ToString -Force -PassThru {$this.Indents}
	}
}
