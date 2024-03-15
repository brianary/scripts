<#
.SYNOPSIS
Tests generating a Mermaid entity relation diagram for database tables.
#>

if(!(Get-Module -List dbatools)) {Install-Module dbatools -Force}
$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Export-MermaidER' -Tag Export-MermaidER -Skip:$skip {
	BeforeAll {
		if(!(Get-Module -List dbatools)) {Install-Module dbatools -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
		$datadir = Join-Path $PSScriptRoot 'data'
		$mockfile = Join-Path $PSScriptRoot mock ([io.path]::ChangeExtension((Split-Path $PSCommandPath -Leaf), 'cs'))
		$server = Connect-DbaInstance $env:TestConnectionString
	}
	Context 'Generates a Mermaid entity relation diagram for database tables' -Tag ExportMermaidER,Export,MermaidER,Mermaid,Diagram,Database {
		It "From the test database, the table '<Table>' generates the diagram in the '<ResultFile>' data file" -Skip:$(!$env:TestConnectionString) -TestCases @(
			@{ Schema = 'Production'; Table = 'Product'; ResultFile = 'AW.Production.Product.mmd' }
		) {
			Param([string] $Schema, [string] $Table, [string] $ResultFile)
			$result = Join-Path $datadir $ResultFile |Get-Item |Get-Content -Raw
			Get-DbaDbTable -SqlInstance $server -Schema $Schema -Table $Table |Export-MermaidER.ps1 |Should -BeExactly $result
		}
		It "From the test database, the schema '<Schema>' generates the diagram in the '<ResultFile>' data file" -Skip:$(!$env:TestConnectionString) -TestCases @(
			@{ Schema = 'Purchasing'; ResultFile = 'AW.Purchasing.mmd' }
		) {
			Param([string] $Schema, [string] $ResultFile)
			$result = Join-Path $datadir $ResultFile |Get-Item |Get-Content -Raw
			Get-DbaDbTable -SqlInstance $server -Schema $Schema |Export-MermaidER.ps1 |Should -BeExactly $result
		}
		It "From the mock Library database, the table '<Table>' generates the diagram in the '<ResultFile>' data file" -Skip:$(!!$env:TestConnectionString) -TestCases @(
			@{ Table = 'Book'; ResultFile = 'Library.dbo.Book.mmd' }
		) {
			Param([string] $Table, [string] $ResultFile)
			try {[void][MockDatabases]} catch {Add-Type -TypeDefinition (Get-Content $mockfile -Raw)}
			$result = Join-Path $datadir $ResultFile |Get-Item |Get-Content -Raw
			[MockDatabases]::Library.Tables[$Table, "dbo"] |Export-MermaidER.ps1 |Should -BeExactly $result
		}
		It "From the mock Library database generates the diagram in the '<ResultFile>' data file" -Skip:$(!!$env:TestConnectionString) -TestCases @(
			@{ ResultFile = 'Library.mmd' }
		) {
			Param([string] $ResultFile)
			try {[void][MockDatabases]} catch {Add-Type -TypeDefinition (Get-Content $mockfile -Raw)}
			$result = Join-Path $datadir $ResultFile |Get-Item |Get-Content -Raw
			[MockDatabases]::Library.Tables |Export-MermaidER.ps1 |Should -BeExactly $result
		}
	}
}
