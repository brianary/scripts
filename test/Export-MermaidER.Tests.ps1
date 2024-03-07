<#
.SYNOPSIS
Tests generating a Mermaid entity relation diagram for database tables.
#>

if(!(Get-Module -List dbatools)) {Install-Module dbatools -Force}
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
Describe 'Export-MermaidER' -Tag Export-MermaidER -Skip:$skip {
	BeforeAll {
		if(!(Get-Module -List dbatools)) {Install-Module dbatools -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
		$datadir = Join-Path $PSScriptRoot 'data'
		$mockfile = Join-Path $PSScriptRoot mock ([io.path]::ChangeExtension((Split-Path $PSCommandPath -Leaf), 'cs'))
		$server,$database = '(localdb)\ProjectsV13','AdventureWorks2016'
	}
	Context 'Generates a Mermaid entity relation diagram for database tables' -Tag ExportMermaidER,Export,MermaidER,Mermaid,Diagram,Database {
		It "From the local AdventureWorks2016 database, the table '<Table>' generates the diagram in the '<ResultFile>' data file" -Skip:$skiplive -TestCases @(
			@{ Server = $server; Database = $database; Schema = 'Production'; Table = 'Product'; ResultFile = 'AW.Production.Product.mmd' }
		) {
			Param([string] $Server, [string] $Database, [string] $Schema, [string] $Table, [string] $ResultFile)
			$result = Join-Path $datadir $ResultFile |Get-Item |Get-Content -Raw
			Get-DbaDbTable -SqlInstance $Server -Database $Database -Schema $Schema -Table $Table |Export-MermaidER.ps1 |Should -BeExactly $result
		}
		It "From the local AdventureWorks2016 database, the schema '<Schema>' generates the diagram in the '<ResultFile>' data file" -Skip:$skiplive -TestCases @(
			@{ Server = $server; Database = $database; Schema = 'Purchasing'; ResultFile = 'AW.Purchasing.mmd' }
		) {
			Param([string] $Server, [string] $Database, [string] $Schema, [string] $ResultFile)
			$result = Join-Path $datadir $ResultFile |Get-Item |Get-Content -Raw
			Get-DbaDbTable -SqlInstance $Server -Database $Database -Schema $Schema |Export-MermaidER.ps1 |Should -BeExactly $result
		}
		It "From the mock Library database, the table '<Table>' generates the diagram in the '<ResultFile>' data file" -Skip:(!$skiplive) -TestCases @(
			@{ Table = 'Book'; ResultFile = 'Library.dbo.Book.mmd' }
		) {
			Param([string] $Table, [string] $ResultFile)
			try {[void][MockDatabases]} catch {Add-Type -TypeDefinition (Get-Content $mockfile -Raw)}
			$result = Join-Path $datadir $ResultFile |Get-Item |Get-Content -Raw
			[MockDatabases]::Library.Tables[$Table, "dbo"] |Export-MermaidER.ps1 |Should -BeExactly $result
		}
		It "From the mock Library database generates the diagram in the '<ResultFile>' data file" -Skip:(!$skiplive) -TestCases @(
			@{ ResultFile = 'Library.mmd' }
		) {
			Param([string] $ResultFile)
			try {[void][MockDatabases]} catch {Add-Type -TypeDefinition (Get-Content $mockfile -Raw)}
			$result = Join-Path $datadir $ResultFile |Get-Item |Get-Content -Raw
			[MockDatabases]::Library.Tables |Export-MermaidER.ps1 |Should -BeExactly $result
		}
	}
}
