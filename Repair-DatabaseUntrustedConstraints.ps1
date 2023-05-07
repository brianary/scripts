<#
.SYNOPSIS
Finds database constraints that have been incompletely re-enabled.

.FUNCTIONALITY
Database

.LINK
Use-SqlcmdParams.ps1

.LINK
Invoke-Sqlcmd

.LINK
https://www.brentozar.com/blitz/foreign-key-trusted/

.EXAMPLE
Repair-DatabaseUntrustedConstraints.ps1 SqlServerName DatabaseName -Update

WARNING: Checked 2 constraints
#>

#Requires -Version 3
#Requires -Module SqlServer
[CmdletBinding(SupportsShouldProcess=$true)][OutputType([void])] Param(
# The name of a server (and optional instance) to connect to.
[Parameter(ParameterSetName='ByConnectionParameters',Position=0,Mandatory=$true)][string] $ServerInstance,
# The the database to connect to on the server.
[Parameter(ParameterSetName='ByConnectionParameters',Position=1,Mandatory=$true)][string] $Database,
# Specifies a connection string to connect to the server.
[Parameter(ParameterSetName='ByConnectionString',Mandatory=$true)][Alias('ConnStr','CS')][string]$ConnectionString,
# Specifies an SMO Database object to query.
[Parameter(ParameterSetName='ByDatabase',Mandatory=$true)]
[Microsoft.SqlServer.Management.Smo.Database] $SmoDatabase,
# The connection string name from the ConfigurationManager to use.
[Parameter(ParameterSetName='ByConnectionName',Mandatory=$true)][string]$ConnectionName,
# Update the database when present, otherwise simply outputs the changes as script.
[switch] $Update
)

Use-SqlcmdParams.ps1

function Resolve-SqlcmdResult([string]$Action,[string]$Query)
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
    $count,$i = 0,0
    [string[]]$commands = Invoke-Sqlcmd $Query |Select-Object -ExpandProperty command
    if(!$commands){return}
    $max,$act = ($commands.Count/100),($Action -f -1,$commands.Count)
    Write-Verbose ($Action -f 1,$commands.Count)
    foreach($command in $commands)
    {
        Write-Progress $act "Execute command #$i" -CurrentOperation $command -PercentComplete ($i++/$max)
        if(!$Update) {$command}
        elseif($PSCmdlet.ShouldProcess($command,'execute')) {Invoke-Sqlcmd $command; $count++}
    }
    Write-Progress ($action -f 0,$i) -Completed
    if($count) {Write-Warning ($Action -f 0,$count)}
}

function Repair-DefaultName
{
    @{
        Action = 'Check{0:;ing;ed} {1} constraints'
        Query  = @"
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
    } |ForEach-Object {Resolve-SqlcmdResults @_}
}

Repair-DefaultNames
