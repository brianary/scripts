<#
.SYNOPSIS
Finds database constraints that have been incompletely re-enabled.

.PARAMETER ServerInstance
The name of a server (and optional instance) to connect to.

.PARAMETER Database
The the database to connect to on the server.

.PARAMETER ConnectionString
Specifies a connection string to connect to the server.

.PARAMETER ConnectionName
The connection string name from the ConfigurationManager to use.

.PARAMETER Update
Update the database when present, otherwise simply outputs the changes as script.

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
[Parameter(ParameterSetName='ByConnectionParameters',Position=0,Mandatory=$true)][string] $ServerInstance,
[Parameter(ParameterSetName='ByConnectionParameters',Position=1,Mandatory=$true)][string] $Database,
[Parameter(ParameterSetName='ByConnectionString',Mandatory=$true)][Alias('ConnStr','CS')][string]$ConnectionString,
[Parameter(ParameterSetName='ByConnectionName',Mandatory=$true)][string]$ConnectionName,
[switch] $Update
)

Use-SqlcmdParams.ps1

function Resolve-SqlcmdResults([string]$Action,[string]$Query)
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
    [string[]]$commands = Invoke-Sqlcmd $Query |% command
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

function Repair-DefaultNames
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
    } |% {Resolve-SqlcmdResults @_}
}

Repair-DefaultNames
