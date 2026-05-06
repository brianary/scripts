<#
.SYNOPSIS
Convert a script from external script usage to module cmdlet usage.

.FUNCTIONALITY
PowerShell

.INPUTS
System.String containing the path of the script to update.
#>

#Requires -Version 7
using namespace System.Collections.Generic
using namespace System.IO
using namespace System.Management.Automation.Language
using module Detextive
[CmdletBinding()] Param(
# The module to use instead of external scripts.
[Parameter(Position=0)][string] $ModuleName = 'ModernConveniences',
# The script to update to module usage.
[Parameter(Position=1,ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string] $Path = '*.ps1'
)
Begin
{
	filter Update-ScriptFile
	{
		[CmdletBinding()] Param(
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][FileInfo[]] $Values,
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
		[System.Collections.ObjectModel.Collection[psobject]] $Group
		)
		if($Values.Count -ne 1) {throw "Unexpected grouping of $($Values.Count) files."}
		$ps1,$cmd = $Values.FullName,$Values.BaseName
		[int] $usingOffset = Get-ScriptTokens $ps1 |
			Where-Object Kind -notin 'Comment','NewLine' |
			Select-Object -First 1 |
			ForEach-Object {$_.Extent.StartOffset}
		$encoding = Get-FileEncoding $ps1
		$script = Get-Content $ps1 -Raw
		$Group |Sort-Object StartOffset -Descending |ForEach-Object {
			$start,$end = $_.StartOffset,$_.EndOffset
			$script = $script.Remove($start, $end - $start).Insert($start, (Split-Path $_.Text -LeafBase))
		}
		$script.Insert($usingOffset, "using module $ModuleName`r`n").Trim() |
			Out-File $ps1 -Encoding $encoding
	}

	function Find-ExternalScriptUsage
	{
		[CmdletBinding()] Param(
		[Parameter(Position=0,Mandatory=$true)][string] $Path
		)
		[string[]] $cmdlets = Get-Command -Module $ModuleName |Select-Object -ExpandProperty Name
		if(!$cmdlets) {throw "Could not find any cmdlets in $ModuleName. Did you import it?"; return}
		return Select-ScriptCommands $Path -CommandType ExternalScript |
			Where-Object {(Split-Path $_.CommandName -LeafBase) -iin $cmdlets} |
			ForEach-Object {$_.Tokens.Extent} |
			Group-Object {Get-Item $_.File}
	}
}
Process
{
	Find-ExternalScriptUsage $Path |Update-ScriptFile
}
