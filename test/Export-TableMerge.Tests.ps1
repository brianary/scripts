<#
.SYNOPSIS
Tests exporting table data as a T-SQL MERGE statement.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Export-TableMerge' -Tag Export-TableMerge -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
		$datadir = Join-Path $PSScriptRoot 'data'
	}
	Context 'Exports table data' -Tag ExportTableMerge,Export,TableMerge,Database {
		It "Exports AdventureWorks HumanResources.Department table data" -Skip:$(!$env:TestConnectionString) {
			$result = Join-Path $datadir HumanResources.Department.merge.sql |Get-Item |Get-Content -Raw
			$result = $result.TrimEnd()
			Export-TableMerge.ps1 -ConnectionString $env:TestConnectionString -Schema HumanResources -Table Department |
				Should -BeExactly $result
		}
	}
}
