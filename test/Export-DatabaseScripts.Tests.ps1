<#
.SYNOPSIS
Tests exporting MS SQL database objects from the given server and database as files, into a consistent folder structure.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Export-DatabaseScripts' -Tag Export-DatabaseScripts -Skip:$skip {
	BeforeAll {
		if(!(Get-Module -List dbatools)) {Install-Module dbatools -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
		Mock Export-DbaScript {}
		$mockfile = Join-Path $PSScriptRoot mock ([io.path]::ChangeExtension((Split-Path $PSCommandPath -Leaf), 'cs'))
		try {[void][MockObject]}
		catch {Add-Type -TypeDefinition (Get-Content $mockfile -Raw)}
	}
	Context 'Exports MS SQL database objects from the given server and database as files, into a consistent folder structure' `
		-Tag ExportDatabaseScripts,Export,DatabaseScripts,Database,SQL {
		It "Export scripts" {
			New-Object Database |Export-DatabaseScripts.ps1
			Assert-MockCalled -CommandName Export-DbaScript -Times 3
		}
	}
}
