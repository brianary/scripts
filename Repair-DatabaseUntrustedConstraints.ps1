<#
.SYNOPSIS
Finds database constraints that have been incompletely re-enabled.

.FUNCTIONALITY
Database

.LINK
https://dbatools.io/

.LINK
Invoke-DbaQuery

.LINK
https://www.brentozar.com/blitz/foreign-key-trusted/

.EXAMPLE
Repair-DatabaseUntrustedConstraints.ps1 SqlServerName DatabaseName -Update

WARNING: Checked 2 constraints
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
function Resolve-QueryResult
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
	Resolve-QueryResult -Action 'Check{0:;ing;ed} {1} constraints' `
		-Query @"
select 'if exists (select * from sys.foreign_keys where object_id = object_id('''
	   + quotename(schema_name(schema_id))
	   + '.' + quotename(object_name(object_id))
	   + ''') and is_not_trusted = 1) alter table '
	   + quotename(object_schema_name(parent_object_id))
	   + '.' + quotename(object_name(parent_object_id))
	   + ' with check check constraint ' + quotename(name) + '; -- FK' command
  from sys.foreign_keys
 where is_not_trusted = 1
   and is_not_for_replication = 0
   and is_disabled = 0
 union all
select 'if exists (select * from sys.foreign_keys where object_id = object_id('''
	   + quotename(schema_name(schema_id))
	   + '.' + quotename(object_name(object_id))
	   + ''') and is_not_trusted = 1) alter table '
	   + quotename(object_schema_name(parent_object_id))
	   + '.' + quotename(object_name(parent_object_id))
	   + ' with check check constraint ' + quotename(name) + ';' command
  from sys.check_constraints
 where is_not_trusted = 1
   and is_not_for_replication = 0
   and is_disabled = 0;
"@
}

Repair-DefaultName
