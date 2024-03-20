<#
.SYNOPSIS
Tests searching a specific subset of files for lines matching a pattern.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Find-Lines' -Tag Find-Lines -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Searches a specific subset of files for lines matching a pattern' -Tag FindLines,Find,Lines {
		It "Finds a line" {
			$found = Find-Lines.ps1 'function Get-LineBlameInfo' *.ps1 -CaseSensitive -SimpleMatch
			$found.Line |Should -BeLike '*function Get-LineBlameInfo*'
		}
		It "Finds a line and adds blame info" {
			$found = Find-Lines.ps1 'function Get-LineBlameInfo' *.ps1 -CaseSensitive -SimpleMatch -Blame
			$found.Line |Should -BeLike '*function Get-LineBlameInfo*'
			$found.Filename |Should -BeLike Find-Lines*
		}
	}
}
