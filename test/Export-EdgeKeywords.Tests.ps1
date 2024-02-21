<#
.SYNOPSIS
Tests returning the configured search keywords from an Edge SQLite file.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Export-EdgeKeywords' -Tag Export-EdgeKeywords -Skip:$skip {
	BeforeAll {
		if(!(Get-Module -List PSSQLite)) {Install-Module PSSQLite -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
		Mock Invoke-SqliteQuery {}
	}
	Context 'Returns the configured search keywords from an Edge SQLite file' -Tag ExportEdgeKeywords,Export,EdgeKeywords {
		It "Queries the default Edge SQLLite file" {
			Export-EdgeKeywords.ps1
			Assert-MockCalled -CommandName Invoke-SqliteQuery -Times 1
		}
	}
}
