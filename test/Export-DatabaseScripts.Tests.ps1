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
		try {[void][MockObject]}
		catch {Add-Type -TypeDefinition @'
public class ScriptNameObjectBase {}
public class MockObject : ScriptNameObjectBase
{
	public string Name { get; } = $"ObjectName{System.DateTime.Now.Microsecond}";
	public string Schema { get; } = "dbo";
	public bool IsSystemObject { get; }
}
public class Database : MockObject
{
	public bool ServiceBroker { get; }
	public MockObject[] Assemblies { get; } = new MockObject[] {};
	public MockObject[] Triggers { get; } = new MockObject[] {};
	public MockObject[] Defaults { get; } = new MockObject[] {};
	public MockObject[] ExtendedProperties { get; } = new MockObject[] {};
	public MockObject[] UserDefinedFunctions { get; } = new MockObject[] {};
	public MockObject[] Rules { get; } = new MockObject[] {};
	public MockObject[] AsymmetricKeys { get; } = new MockObject[] {};
	public MockObject[] Certificates { get; } = new MockObject[] {};
	public MockObject[] Roles { get; } = new MockObject[] {};
	public MockObject[] Schemas { get; } = new MockObject[] {};
	public MockObject[] SymmetricKeys { get; } = new MockObject[] {};
	public MockObject[] Users { get; } = new MockObject[] {};
	public MockObject[] Sequences { get; } = new MockObject[] {};
	public MockObject[] FullTextCatalogs { get; } = new MockObject[] {};
	public MockObject[] FullTextStopLists { get; } = new MockObject[] {};
	public MockObject[] PartitionFunctions { get; } = new MockObject[] {};
	public MockObject[] PartitionSchemes { get; } = new MockObject[] {};
	public MockObject[] StoredProcedures { get; } = new MockObject[] { new MockObject() };
	public MockObject[] Synonyms { get; } = new MockObject[] {};
	public MockObject[] Tables { get; } = new MockObject[] { new MockObject() };
	public MockObject[] UserDefinedDataTypes { get; } = new MockObject[] {};
	public MockObject[] XmlSchemaCollections { get; } = new MockObject[] {};
	public MockObject[] Views { get; } = new MockObject[] { new MockObject() };
}
'@}
	}
	Context 'Exports MS SQL database objects from the given server and database as files, into a consistent folder structure' `
		-Tag ExportDatabaseScripts,Export,DatabaseScripts,Database,SQL {
		It "Export scripts" {
			New-Object Database |Export-DatabaseScripts.ps1
			Assert-MockCalled -CommandName Export-DbaScript -Times 3
		}
	}

}
