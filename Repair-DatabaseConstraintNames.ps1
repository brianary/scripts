<#
.Synopsis
    Finds database constraints with system-generated names and gives them deterministic names.

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
    Invoke-Sqlcmd

.Example
    Repair-DatabaseConstraintNames.ps1 sqlpizza\supreme WebForms -Update


    WARNING: Renamed 10 defaults.
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
        Action = 'Renam{0:e;ing;ed} {1} defaults'
        Query  = @"
select 'exec sp_rename '''+quotename(schema_name(schema_id))+'.'+quotename(name)
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
    }| % {Resolve-SqlcmdResults @_}
}

function Repair-PrimaryKeyNames
{
    @{
        Action = 'Renam{0:e;ing;ed} {1} primary keys'
        Query  = @"
select 'exec sp_rename '''+quotename(schema_name(schema_id))+'.'+quotename(name)
       +''', '''+'PK_'+object_name(parent_object_id)+''', ''OBJECT'';' command
  from sys.key_constraints 
 where name like 'PK._._%' escape '.'
   and name <> 'PK_'+object_name(parent_object_id)
   and objectproperty(parent_object_id,'IsUserTable') = 1 -- excludes 'sys' schema, &c
   and objectproperty(parent_object_id,'IsMsShipped') = 0 -- excludes dtproperties, &c
   and parent_object_id not in (select major_id from sys.extended_properties
       where class = 1 and minor_id = 0 and name = 'microsoft_database_tools_support'); -- excludes sysdiagrams, &c
"@
    }| % {Resolve-SqlcmdResults @_}
}

function Repair-ForeignKeyNames
{ #TODO: Mitigate possible deterministic naming collisions.
    @{
        Action = 'Renam{0:e;ing;ed} {1} foreign keys'
        Query  =  @"
select 'exec sp_rename '''+quotename(schema_name(schema_id))+'.'+quotename(name)
       +''', '''+'FK_'+object_name(parent_object_id)+'_'+object_name(referenced_object_id)+''', ''OBJECT'';' command
  from sys.foreign_keys 
 where name like 'FK._._%' escape '.'
   and name <> 'FK_'+object_name(parent_object_id)
   and objectproperty(parent_object_id,'IsUserTable') = 1 -- excludes 'sys' schema, &c
   and objectproperty(parent_object_id,'IsMsShipped') = 0 -- excludes dtproperties, &c
   and parent_object_id not in (select major_id from sys.extended_properties
       where class = 1 and minor_id = 0 and name = 'microsoft_database_tools_support'); -- excludes sysdiagrams, &c
"@
    }| % {Resolve-SqlcmdResults @_}
}

Repair-DefaultNames
Repair-PrimaryKeyNames
Repair-ForeignKeyNames
