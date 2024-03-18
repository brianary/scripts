<#
.SYNOPSIS
Tests searching for database columns.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Find-DbColumn' -Tag Find-DbColumn -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Searches for database columns' -Tag FindDbColumn,Find,DbColumn,Database {
		It "Finds price columns in the test database" -Skip:$(!$env:TestConnectionString) {
			Find-DbColumn.ps1 -ConnectionString $env:TestConnectionString -IncludeColumns %price% |
				Select-Object -ExpandProperty ColumnName |
				Should -BeLike '*Price*'
		}
	}
}
