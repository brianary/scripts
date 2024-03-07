<#
.SYNOPSIS
Tests exporting table data as a T-SQL MERGE statement.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
$server,$database = '(localdb)\ProjectsV13','AdventureWorks2016'
$skiplive =
	if(Test-Path .NO_DB -Type Leaf) {$true}
	elseif($skip) {$true}
	elseif(!(Get-Module -List dbatools)) {$true}
	elseif(!(Get-Command Test-DbaConnection -Module dbatools -ErrorAction Ignore)) {$true}
	elseif(!(Test-DbaConnection -SqlInstance $server -SkipPSRemoting |Select-Object -ExpandProperty ConnectSuccess)) {$true}
	else {$false}
if($skiplive)
{
	if(!(Test-Path .NO_DB -Type Leaf)) {New-Item .NO_DB -Type File}
	Write-Information "[$server].[$database] is not accessible, skipping live tests" -infa Continue
}
Describe 'Export-TableMerge' -Tag Export-TableMerge -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
		$server,$database = '(localdb)\ProjectsV13','AdventureWorks2016'
	}
	Context 'Exports table data' -Tag ExportTableMerge,Export,TableMerge,Database {
		It "Exports AdventureWorks Production.Product table data" -Skip:$skiplive {
			Export-TableMerge -Server $server -Database $database -Schema Production -Table Product |Should -BeExactly @"
TODO
"@
		}
	}
}
