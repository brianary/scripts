<#
.SYNOPSIS
Exports MS SQL database objects from the given server and database as files, into a consistent folder structure.

.DESCRIPTION
This script exports all database objects as scripts into a subdirectory with the same name as the database,
and further subdirectories by object type. The directory is deleted and recreated each time this script is
run, to clean up objects that have been deleted from the database.

.FUNCTIONALITY
Database

.LINK
https://msdn.microsoft.com/library/microsoft.sqlserver.management.smo.scriptingoptions_properties.aspx

.LINK
Export-DbaScript

.LINK
New-DbaScriptingOption

.EXAMPLE
Get-DbaDatabase -SqlInstance ServerName\instance -Database AdventureWorks2014 |Export-DatabaseScript.ps1

Outputs SQL scripts to files using the default options.
#>

#Requires -Version 3
#Requires -Modules dbatools
[CmdletBinding()][OutputType([void])] Param(
# The database from which to export scripts.
[Parameter(ValueFromPipeline=$true,Mandatory=$true)]
[Microsoft.SqlServer.Management.Smo.Database] $Database,
# Controls how the scripts are generated.
[Microsoft.SqlServer.Management.Smo.ScriptingOptions] $Options = (New-DbaScriptingOption)
)

function ConvertTo-FileName($Name) { $Name -replace '[:<>\\/"|\t]+','_' }
filter Test-SystemObject
{
	Param(
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string] $Name,
	[Parameter(ValueFromPipelineByPropertyName=$true)][bool] $IsSystemObject = $false
	)
	return $IsSystemObject
}

filter Get-ScriptName
{
	[CmdletBinding()] Param(
	[Parameter(Position=0,Mandatory=$true)][string] $Subfolder,
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string] $Name,
	[Parameter(ValueFromPipelineByPropertyName=$true)][string] $Schema
	)
	if(!(Test-Path $Subfolder -Type Container)) {New-Item $Subfolder -Type Directory |Out-Null}
	return Join-Path $Subfolder (ConvertTo-FileName ($Schema ? "$Schema.$Name.sql" : "$Name.sql"))
}

filter Export-DatabaseScript
{
	[CmdletBinding()] Param(
	[Parameter(Position=0,Mandatory=$true)][string] $Subfolder,
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	[Microsoft.SqlServer.Management.Smo.ScriptNameObjectBase] $InputObject
	)
	if(!$InputObject -or ($InputObject |Test-SystemObject)) {return}
	$InputObject |Export-DbaScript -ScriptingOptionsObject $Options -FilePath ($InputObject |Get-ScriptName $Subfolder)
}

function Export-DatabaseObjects
{
	[CmdletBinding()] Param()
	$dir = (ConvertTo-FileName $Database.Name)
	if(Test-Path $dir)
	{
		Stop-ThrowError.ps1 "Directory $dir already exists" -OperationContext $dir
	}
	New-Item $dir -Type Directory |Push-Location
	$Database.Assemblies |Export-DatabaseScript 'Assemblies'
	$Database.Triggers |Export-DatabaseScript 'Database Triggers'
	$Database.Defaults |Export-DatabaseScript 'Defaults'
	$Database.ExtendedProperties |Export-DatabaseScript 'Extended Properties'
	$Database.UserDefinedFunctions |Export-DatabaseScript 'Functions'
	$Database.Rules |Export-DatabaseScript 'Rules'
	$Database.AsymmetricKeys |Export-DatabaseScript 'Security/Asymmetric Keys'
	$Database.Certificates |Export-DatabaseScript 'Security/Certificates'
	$Database.Roles |
		Where-Object {$_ -isnot [Microsoft.SqlServer.Management.Smo.DatabaseRole] -or !$_.IsFixedRole} |
		Export-DatabaseScript 'Security/Roles'
	$Database.Schemas |Export-DatabaseScript 'Security/Schemas'
	$Database.SymmetricKeys |Export-DatabaseScript 'Security/Symmetric Keys'
	$Database.Users |Export-DatabaseScript 'Security/Users'
	$Database.Sequences |Export-DatabaseScript 'Sequences'
	$Database.FullTextCatalogs |Export-DatabaseScript 'Storage/Full Text Catalogs'
	$Database.FullTextStopLists |Export-DatabaseScript 'Storage/Full Text Stop Lists'
	$Database.PartitionFunctions |Export-DatabaseScript 'Storage/Partition Functions'
	$Database.PartitionSchemes |Export-DatabaseScript 'Storage/Partition Schemes'
	$Database.StoredProcedures |Export-DatabaseScript 'Stored Procedures'
	$Database.Synonyms |Export-DatabaseScript 'Synonyms'
	$Database.Tables |Export-DatabaseScript 'Tables'
	$Database.UserDefinedDataTypes |Export-DatabaseScript 'Types/User-defined Data Types'
	$Database.XmlSchemaCollections |Export-DatabaseScript 'Types/XML Schema Collections'
	$Database.Views |Export-DatabaseScript 'Views'
	if($Database.ServiceBroker)
	{
		$Database.ServiceBroker.ServiceContracts |Export-DatabaseScript 'Service Broker/Contracts'
		#$Database.ServiceBroker.? |Export-DatabaseScript 'Service Broker/Event Notifications'
		$Database.ServiceBroker.MessageTypes |Export-DatabaseScript 'Service Broker/Message Types'
		$Database.ServiceBroker.Queues |Export-DatabaseScript 'Service Broker/Queues'
		$Database.ServiceBroker.RemoteServiceBindings |Export-DatabaseScript 'Service Broker/Remote Service Bindings'
		$Database.ServiceBroker.Routes |Export-DatabaseScript 'Service Broker/Routes'
		$Database.ServiceBroker.Services |Export-DatabaseScript 'Service Broker/Services'
	}
	Pop-Location
}

Export-DatabaseObjects
