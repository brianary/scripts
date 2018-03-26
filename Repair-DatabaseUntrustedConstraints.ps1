<#
.Synopsis
    Finds database constraints that have been incompletely re-enabled.

.Parameter ServerInstance
    The name of a server (and optional instance) to connect to.

.Parameter Database
    The the database to connect to on the server.

.Parameter ConnectionString
    Specifies a connection string to connect to the server.

.Parameter ConnectionName
    The connection string name from the ConfigurationManager to use.

.Parameter Update
    Update the database when present, otherwise simply outputs the changes as script.

.Link
    https://www.brentozar.com/blitz/foreign-key-trusted/

.Link
    Invoke-Sqlcmd

.Example
    Repair-DatabaseUntrustedConstraints.ps1 SqlServerName DatabaseName -Update

    WARNING: Checked 2 constraints
#>

#Requires -Version 3
#Requires -Module SqlServer
[CmdletBinding(SupportsShouldProcess=$true)] Param(
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
    .Synopsis
        Executes SQL that generates SQL strings, and optionally executes the generated SQL.

    .Parameter Action
        Descriptive text for the commands produced, with two format arguments:
          0: Verb tense, e.g. 'Renam{0:e;ing;ed}'
          1: Command count

    .Parameter Query
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
select 'alter table ' + quotename(schemas.name) + '.' + quotename(objects.name)
        + ' with check check constraint ' + quotename(foreign_keys.name) + '; -- FK' command
   from sys.foreign_keys
   join sys.objects
     on foreign_keys.parent_object_id = objects.object_id
   join sys.schemas
     on objects.schema_id = schemas.schema_id
  where foreign_keys.is_not_trusted = 1
    and foreign_keys.is_not_for_replication = 0
    and foreign_keys.is_disabled = 0
 union all
 select 'alter table ' + quotename(schemas.name) + '.' + quotename(objects.name)
        + ' with check check constraint ' + quotename(check_constraints.name) + ';'
   from sys.check_constraints
   join sys.objects
     on check_constraints.parent_object_id = objects.object_id
   join sys.schemas
     on objects.schema_id = schemas.schema_id
  where check_constraints.is_not_trusted = 1
    and check_constraints.is_not_for_replication = 0
    and check_constraints.is_disabled = 0;
"@
    } |% {Resolve-SqlcmdResults @_}
}

Repair-DefaultNames
