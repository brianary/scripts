<#
.SYNOPSIS
Exports MS SQL database objects from the given server and database as files, into a consistent folder structure.

.DESCRIPTION
This script exports all database objects as scripts into a subdirectory with the same name as the database,
and further subdirectories by object type. The directory is deleted and recreated each time this script is
run, to clean up objects that have been deleted from the database.

There are a default set of SMO scripting options set to do a typical export, though these may be overridden
(see the link below for a list of these options).

This does require SMO to be installed on the machine (it comes with SQL Management Studio).

.FUNCTIONALITY
Database

.COMPONENT
Microsoft.SqlServer.Smo.Server

.COMPONENT
Microsoft.SqlServer.Management.Smo.ScriptingOptions

.LINK
https://msdn.microsoft.com/library/microsoft.sqlserver.management.smo.aspx

.LINK
https://msdn.microsoft.com/library/microsoft.sqlserver.management.smo.scriptingoptions_properties.aspx

.EXAMPLE
Export-DatabaseScripts.ps1 ServerName\instance AdventureWorks2014

Outputs SQL scripts to files.
#>

#Requires -Version 3
#Requires -Module SqlServer
[CmdletBinding()][OutputType([void])] Param(
# The name of the server (and instance) to connect to.
[Parameter(Position=0,Mandatory=$true)][string] $Server,
# The name of the database to connect to on the server.
[Parameter(Position=1,Mandatory=$true)][string] $Database,
# The file encoding to use for the SQL scripts.
[Parameter(Position=2)][ValidateSet('Unicode','UTF7','UTF8','UTF32','ASCII','BigEndianUnicode','Default','OEM')][string]$Encoding = 'UTF8',
# Provides a list of boolean SMO ScriptingOptions properties to set to true.
[Parameter(Position=3,ValueFromRemainingArguments=$true)][string[]] $ScriptingOptions = (@'
EnforceScriptingOptions ExtendedProperties Permissions DriAll Indexes Triggers ScriptBatchTerminator
'@.Trim() -split '\W+'),
<#
The SQL version to target when scripting.
By default, uses the version from the source server.
Versions greater than the source server's version may fail.
#>
[Microsoft.SqlServer.Management.Smo.SqlServerVersion]$SqlVersion
)

# connect to database
$srv = New-Object Microsoft.SqlServer.Management.Smo.Server($Server)
if(!$SqlVersion)
{
	[Microsoft.SqlServer.Management.Smo.SqlServerVersion]$SqlVersion = "Version$($srv.VersionMajor)$($srv.VersionMinor/10)"
}
$db = $srv.Databases[$Database]
if(!$db) {return}
Write-Verbose "Connected to $srv.$db $($srv.Product) $($srv.Edition) $($srv.VersionString) $($srv.ProductLevel) (Windows $($srv.OSVersion))"
if((Test-Path $Database -PathType Container)) { Remove-Item -Force -Recurse $Database } # to reflect removed items
mkdir $Database -EA:SilentlyContinue |Out-Null ; Push-Location $Database

# set up scripting options
$opts = New-Object Microsoft.SqlServer.Management.Smo.ScriptingOptions
$ScriptingOptions |
	% {
		if(($opts |Get-Member $_) -and $opts.$_ -is [bool]) {$opts.$_ = $true}
		else {Write-Warning "Not a boolean scripting option: '$_'"}
	}
$opts.TargetServerVersion = $SqlVersion
$opts.ToFileOnly = $true
$opts.Encoding =
	if($Encoding -eq 'OEM') {$OutputEncoding.GetEncoder().Encoding}
	else {[Text.Encoding]::$Encoding}
Write-Verbose "Scripting options flags: $(($opts |Get-Member -MemberType Property |% Name |? {$opts.$_ -is [bool] -and $opts.$_}) -join ', ')"
Write-Verbose "Scripting options values: $(($opts |Get-Member -MemberType Property |% Name |? {$opts.$_ -isnot [bool] -and $opts.$_} |% {"$_=$($opts.$_)"}) -join ', ')"

# map database SMO object collection properties to folder structure
$folder = @{
	# Property           = # Folder
	Assemblies           = 'Assemblies'
	Triggers             = 'Database Triggers'
	Defaults             = 'Defaults'
	ExtendedProperties   = 'Extended Properties'
	UserDefinedFunctions = 'Functions'
	Rules                = 'Rules'
	AsymmetricKeys       = 'Security\Asymmetric Keys'
	Certificates         = 'Security\Certificates'
	Roles                = 'Security\Roles'
	Schemas              = 'Security\Schemas'
	SymmetricKeys        = 'Security\Symmetric Keys'
	Users                = 'Security\Users'
	Sequences            = 'Sequences'
	FullTextCatalogs     = 'Storage\Full Text Catalogs'
	FullTextStopLists    = 'Storage\Full Text Stop Lists'
	PartitionFunctions   = 'Storage\Partition Functions'
	PartitionSchemes     = 'Storage\Partition Schemes'
	StoredProcedures     = 'Stored Procedures'
	Synonyms             = 'Synonyms'
	Tables               = 'Tables'
	UserDefinedDataTypes = 'Types\User-defined Data Types'
	XmlSchemaCollections = 'Types\XML Schema Collections'
	Views                = 'Views'
}
$brkr = @{ # not something we currently use
	ServiceContracts      = 'Service Broker\Contracts'
	# ?                   = 'Service Broker\Event Notifications'
	MessageTypes          = 'Service Broker\Message Types'
	Queues                = 'Service Broker\Queues'
	RemoteServiceBindings = 'Service Broker\Remote Service Bindings'
	Routes                = 'Service Broker\Routes'
	Services              = 'Service Broker\Services'
}

function ConvertTo-FileName($Name) { $Name -replace '[<>\\/"|\t]+','_' }

# script all mapped SMO object collection properties
# skip collections that are empty, only system objects, and only fixed roles
# skip system objects and fixed roles
$folder.Keys |
	? {$db.$_ -and $db.$_.Count} |
	? {$db.$_ -isnot [Microsoft.SqlServer.Management.Smo.DatabaseRoleCollection] -or ($db.$_ |? IsFixedRole -eq $false)} |
	? {!($db.$_ |Get-Member IsSystemObject) -or ($db.$_ |? IsSystemObject -eq $false)} |
	% {
		mkdir $folder.$_ -EA:SilentlyContinue |Out-Null ; Push-Location $folder.$_
		$db.$_ |
			? {!($_|Get-Member IsSystemObject) -or !($_.IsSystemObject)} |
			? {$_ -isnot [Microsoft.SqlServer.Management.Smo.DatabaseRole] -or !($_.IsFixedRole)} |
			% {
				$opts.FileName =
					if($_|Get-Member Schema) {"$pwd\$(ConvertTo-FileName $_.Schema).$(ConvertTo-FileName $_.Name).sql"}
					else {"$pwd\$(ConvertTo-FileName $_.Name).sql"}
				Write-Verbose "Export $($_.GetType().Name) $_ to $($opts.FileName)"
				$_.Script($opts)
			}
		Pop-Location # object collection folder
	}

Pop-Location # Database
