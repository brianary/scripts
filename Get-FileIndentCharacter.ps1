<#
.Synopsis
	Determines the indent characters used in a text file.

.Parameter Path
	The location of a file.

.Inputs
	Any object with a Path or FullName property to use for a file location.

.Outputs
	System.String containing:

	* Tabs if the file only contains HT indents.
	* Spaces if the file only contains PS indents.
	* Mixed (HT=n, SP=m, other/combined=k) if the file contains multiple different indents.
	* None if the file contains no indents.

.Link
	Select-String

.Example
	Get-FileIndentCharacter.ps1 Get-FileIndentCharacter.ps1
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string] $Path
)
Begin
{
	Set-Variable HT ([char]0x9) -Option Constant
	Set-Variable SP ([char]0x20) -Option Constant
}
Process
{
	$countTab,$countSpace,$countMixed = 0,0,0
	foreach($indent in Select-String '^(\s+)' $Path |foreach {$_.Matches.Groups[0].Value})
	{
		if($indent.Trim(@($HT)) -eq '') {$countTab++}
		elseif($indent.Trim(@($SP)) -eq '') {$countSpace++}
		else {$countMixed++}
	}
	Write-Verbose "Indent counts: HT=$countTab, SP=$countSpace, other/combined=$countMixed"
	if($countTab) { if($countSpace -or $countMixed) {"Mixed (HT=$countTab, SP=$countSpace, other/combined=$countMixed)"} else {'Tabs'} }
	elseif($countSpace) { if($countMixed) {"Mixed (HT=$countTab, SP=$countSpace, other/combined=$countMixed)"} else {'Spaces'} }
	elseif($countMixed) {"Mixed (HT=$countTab, SP=$countSpace, other/combined=$countMixed)"}
	else {'None'}
}
