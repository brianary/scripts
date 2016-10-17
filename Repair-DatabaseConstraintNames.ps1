<#
.Synopsis
    Finds database constraints with system-generated names and gives them deterministic names.

.Parameter ServerInstance
    The server and instance to connect to.

.Parameter Database
    The database to use.

.Parameter Update
    Update the database when present, otherwise simply outputs the changes as script.

.Link
    Invoke-Sqlcmd

.Example
    Repair-DatabaseConstraintNames.ps1 sqlpizza\supreme WebForms -Update


    WARNING: Renamed 10 defaults.
#>

#Requires -Version 3
#Requires -Module SQLPS
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string] $ServerInstance,
[Parameter(Position=1,Mandatory=$true)][string] $Database,
[switch] $Update
)

$Script:PSDefaultParameterValues = @{
    "Invoke-Sqlcmd:ServerInstance" = $ServerInstance
    "Invoke-Sqlcmd:Database"       = $Database
}

function Repair-DefaultNames
{
$count = 0
Invoke-Sqlcmd @"
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
"@ |%{
        if($Update) {Invoke-Sqlcmd $_.command; $count++}
        else {$_.command}
    }
if($count) {Write-Warning "Renamed $count defaults."}
}

function Repair-PrimaryKeyNames
{
$count = 0
Invoke-Sqlcmd @"
select 'exec sp_rename '''+quotename(schema_name(schema_id))+'.'+quotename(name)
       +''', '''+'PK_'+object_name(parent_object_id)+''', ''OBJECT'';' command
  from sys.key_constraints 
 where name like 'PK._._%' escape '.'
   and name <> 'PK_'+object_name(parent_object_id)
   and objectproperty(parent_object_id,'IsUserTable') = 1 -- excludes 'sys' schema, &c
   and objectproperty(parent_object_id,'IsMsShipped') = 0 -- excludes dtproperties, &c
   and parent_object_id not in (select major_id from sys.extended_properties
       where class = 1 and minor_id = 0 and name = 'microsoft_database_tools_support'); -- excludes sysdiagrams, &c
"@ |%{
        if($Update) {Invoke-Sqlcmd $_.command; $count++}
        else {$_.command}
    }
if($count) {Write-Warning "Renamed $count primary keys."}
}

function Repair-ForeignKeyNames
{ #TODO: Mitigate possible deterministic naming collisions.
$count = 0
Invoke-Sqlcmd @"
select 'exec sp_rename '''+quotename(schema_name(schema_id))+'.'+quotename(name)
       +''', '''+'FK_'+object_name(parent_object_id)+'_'+object_name(referenced_object_id)+''', ''OBJECT'';' command
  from sys.foreign_keys 
 where name like 'FK._._%' escape '.'
   and name <> 'FK_'+object_name(parent_object_id)
   and objectproperty(parent_object_id,'IsUserTable') = 1 -- excludes 'sys' schema, &c
   and objectproperty(parent_object_id,'IsMsShipped') = 0 -- excludes dtproperties, &c
   and parent_object_id not in (select major_id from sys.extended_properties
       where class = 1 and minor_id = 0 and name = 'microsoft_database_tools_support'); -- excludes sysdiagrams, &c
"@ |%{
        if($Update) {Invoke-Sqlcmd $_.command; $count++}
        else {$_.command}
    }
if($count) {Write-Warning "Renamed $count primary keys."}
}

Repair-DefaultNames
Repair-PrimaryKeyNames
Repair-ForeignKeyNames
