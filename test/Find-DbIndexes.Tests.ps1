<#
.SYNOPSIS
Tests returning indexes using a column with the given name.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Find-DbIndexes' -Tag Find-DbIndexes -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Returns indexes using a column with the given name' -Tag FindDbIndexes,Find,DbIndexes,Database {
		It "Finds the ErrorLog ID" -Skip:$(!$env:TestConnectionString) {
			$index = Find-DbIndexes.ps1 -ConnectionString $env:TestConnectionString -ColumnName ErrorLogID
			$index.IndexName |Should -BeExactly PK_ErrorLog_ErrorLogID
			$index.TableName |Should -BeExactly ErrorLog
		}
	}
}
