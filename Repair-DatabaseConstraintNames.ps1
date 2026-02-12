<#
.SYNOPSIS
Finds database constraints with system-generated names and gives them deterministic names.

.FUNCTIONALITY
Database

.LINK
https://dbatools.io/

.LINK
Invoke-DbaQuery

.LINK
https://www.databasejournal.com/features/mssql/article.php/1570801/Beware-of-the-System-Generated-Constraint-Name.htm

.EXAMPLE
Repair-DatabaseConstraintNames.ps1 SqlServerName DatabaseName -Update

WARNING: Renamed 10 defaults
#>

#Requires -Version 7
using module dbatools
using namespace Microsoft.SqlServer.Management.Smo
[CmdletBinding(SupportsShouldProcess=$true)][OutputType([void])] Param(
# The server to use, by name or constructed via Connect-DbaInstance.
[Parameter(Position=0,Mandatory=$true)][Alias('Parent','ServerInstance')][DbaInstanceParameter] $SqlInstance,
# The the database to connect to on the server.
[Parameter(Position=1)][Alias('Name')][string] $Database,
# Update the database when present, otherwise simply outputs the changes as script.
[switch] $Update
)
Use-DbInstance.ps1 -As PSObject
function Resolve-SqlcmdResult
{
<#
.SYNOPSIS
Executes SQL that generates SQL strings, and optionally executes the generated SQL.

.PARAMETER Action
Descriptive text for the commands produced, with two format arguments:
0: Verb tense, e.g. 'Renam{0:e;ing;ed}'
1: Command count

.PARAMETER Query
A SQL query that produces a single-column result set, named "command", containing
executable SQL.
#>
	[CmdletBinding(SupportsShouldProcess=$true)] Param([string]$Action,[string]$Query)
	$count,$i = 0,0
	[string[]]$commands = Invoke-DbaQuery -Query $Query -As SingleValue
	if(!$commands){return}
	$max,$act = ($commands.Count/100),($Action -f -1,$commands.Count)
	Write-Verbose ($Action -f 1,$commands.Count)
	foreach($command in $commands)
	{
		Write-Progress $act "Execute command #$i" -CurrentOperation $command -PercentComplete ($i++/$max)
		if(!$Update) {$command}
		elseif($PSCmdlet.ShouldProcess($command,'execute')) {Invoke-DbaQuery -Query $command -As PSObject; $count++}
	}
	Write-Progress ($action -f 0,$i) -Completed
	if($count) {Write-Warning ($Action -f 0,$count)}
}

function Repair-DefaultName
{
	@{
		Action = 'Renam{0:e;ing;ed} {1} defaults'
		Query  = @"
select 'if object_id(''' + quotename(schema_name(schema_id)) +'.'+ quotename(name)
	   +''') is not null exec sp_rename '''+quotename(schema_name(schema_id))+'.'+quotename(name)
	   +''', ''DF_'+object_name(parent_object_id)+'_'+col_name(parent_object_id,parent_column_id)
	   +''', ''OBJECT'';' [command]
  from sys.default_constraints
 where name like 'DF._._%' escape '.'
   and name <> 'DF_'+object_name(parent_object_id)+'_'+col_name(parent_object_id,parent_column_id)
   and objectproperty(parent_object_id,'IsUserTable') = 1 -- excludes 'sys' schema, &c
   and objectproperty(parent_object_id,'IsMsShipped') = 0 -- excludes dtproperties, &c
   and parent_object_id not in (select major_id from sys.extended_properties
	   where class = 1 and minor_id = 0 and name = 'microsoft_database_tools_support'); -- excludes sysdiagrams, &c
"@
	} |ForEach-Object {Resolve-SqlcmdResult @_}
}

function Repair-PrimaryKeyName
{
	@{
		Action = 'Renam{0:e;ing;ed} {1} primary keys'
		Query  = @"
select 'if object_id(''' + quotename(schema_name(schema_id)) +'.'+ quotename(name)
	   +''') is not null exec sp_rename '''+quotename(schema_name(schema_id))+'.'+quotename(name)
	   +''', '''+'PK_'+object_name(parent_object_id)+''', ''OBJECT'';' command
  from sys.key_constraints
 where name like 'PK._._%' escape '.'
   and name <> 'PK_'+object_name(parent_object_id)
   and objectproperty(parent_object_id,'IsUserTable') = 1 -- excludes 'sys' schema, &c
   and objectproperty(parent_object_id,'IsMsShipped') = 0 -- excludes dtproperties, &c
   and parent_object_id not in (select major_id from sys.extended_properties
	   where class = 1 and minor_id = 0 and name = 'microsoft_database_tools_support'); -- excludes sysdiagrams, &c
"@
	} |ForEach-Object {Resolve-SqlcmdResult @_}
}

function Repair-ForeignKeyName
{ #TODO: Mitigate possible deterministic naming collisions.
	@{
		Action = 'Renam{0:e;ing;ed} {1} foreign keys'
		Query  =  @"
select 'if object_id(''' + quotename(schema_name(schema_id)) +'.'+ quotename(name)
	   +''') is not null exec sp_rename '''+quotename(schema_name(schema_id))+'.'+quotename(name)
	   +''', '''+'FK_'+object_name(parent_object_id)+'_'+object_name(referenced_object_id)+''', ''OBJECT'';' command
  from sys.foreign_keys
 where name like 'FK._._%' escape '.'
   and name <> 'FK_'+object_name(parent_object_id)
   and objectproperty(parent_object_id,'IsUserTable') = 1 -- excludes 'sys' schema, &c
   and objectproperty(parent_object_id,'IsMsShipped') = 0 -- excludes dtproperties, &c
   and parent_object_id not in (select major_id from sys.extended_properties
	   where class = 1 and minor_id = 0 and name = 'microsoft_database_tools_support'); -- excludes sysdiagrams, &c
"@
	} |ForEach-Object {Resolve-SqlcmdResult @_}
}

Repair-DefaultName
Repair-PrimaryKeyName
Repair-ForeignKeyName
