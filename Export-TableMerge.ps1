<#
.SYNOPSIS
Exports table data as a T-SQL MERGE statement.

.PARAMETER ServerInstance
The name of a server (and optional instance) to connect and use for the query.
May be used with optional Database, Credential, and ConnectionProperties parameters.

.PARAMETER Database
The the database to connect to on the server.

.PARAMETER ConnectionString
Specifies a connection string to connect to the server.

.PARAMETER ConnectionName
The connection string name from the ConfigurationManager to use.

.PARAMETER Table
The name of the table to export.

.PARAMETER Schema
Optional name of the table's schema.
By default, uses the user's default schema defined in the database (typically dbo).

.PARAMETER UseIdentityAsKey
Treat a non-key identity column as part of the key, since it can't be updated as a data column.

Non-key identity columns are very rare, but if one is detected and this switch is not specified,
a warning will be generated and the column will be ignored entirely for updates, and not used as
either a key to match on or a data column to update.

.OUTPUTS
System.String of SQL MERGE script to replicate the table's data.

.LINK
Use-SqlcmdParams.ps1

.LINK
Invoke-Sqlcmd

.LINK
https://msdn.microsoft.com/library/hh245198.aspx

.EXAMPLE
Export-TableMerge $server pubs employee |Out-File employee.sql

.EXAMPLE
Export-TableMerge -Server "(localdb)\ProjectV12" -Database AdventureWorks2014 -Schema Production -Table Product |Out-File Data\Production.Product.sql utf8
#>

#Requires -Version 3
#Requires -Module SqlServer
[CmdletBinding()][OutputType([string])] Param(
[Parameter(ParameterSetName='ByConnectionParameters',Position=0,Mandatory=$true)][string] $ServerInstance,
[Parameter(ParameterSetName='ByConnectionParameters',Position=1,Mandatory=$true)][string] $Database,
[Parameter(ParameterSetName='ByConnectionString',Mandatory=$true)][Alias('ConnStr','CS')][string] $ConnectionString,
[Parameter(ParameterSetName='ByConnectionName',Mandatory=$true)][string] $ConnectionName,
[Parameter(Position=2,Mandatory=$true)][string] $Table,
[Parameter(Position=3)][string] $Schema,
[switch] $UseIdentityInKey
)

Use-SqlcmdParams.ps1

function Format-SqlValue($value)
{
    if($value -is [DBNull]) {'null'}
    elseif($value -is [string]) {"'{0}'" -f ($value -replace "'","''")}
    elseif($value -is [datetime]) {"'{0}'" -f $value} # hmm… format? type?
    elseif($value -is [bool]) {if($value){1}else{0}}
    elseif($value -is [guid]) {"'{0}'" -f $value}
    else {$value}
}

$tablename = Format-SqlValue $Table
if(!$Schema){$Schema = Invoke-Sqlcmd "select object_schema_name(object_id($tablename)) as schema_name" |% schema_name}
$schemaname = Format-SqlValue $Schema
$fqtn = Invoke-Sqlcmd "select quotename($schemaname) + '.' + quotename($tablename) as fqtn" |% fqtn
$rowcount = Invoke-Sqlcmd "select count(*) rows from $fqtn" |% rows
if($rowcount -gt 10000) {Write-Warning "The table $fqtn contains $rowcount rows, which may not export well as a merge script."}
else {Write-Verbose "Exporting $rowcount rows from table $fqtn."}

$pk = Invoke-Sqlcmd @"
select quotename(kcu.COLUMN_NAME) as COLUMN_NAME
  from INFORMATION_SCHEMA.TABLE_CONSTRAINTS as tc
  join INFORMATION_SCHEMA.KEY_COLUMN_USAGE as kcu
    on kcu.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA
   and kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
   and kcu.TABLE_SCHEMA = tc.TABLE_SCHEMA
   and kcu.TABLE_NAME = tc.TABLE_NAME
 where tc.TABLE_SCHEMA = $schemaname
   and tc.TABLE_NAME = $tablename
   and tc.CONSTRAINT_TYPE = 'PRIMARY KEY' -- UNIQUE?
 order by kcu.ORDINAL_POSITION;
"@ |% COLUMN_NAME
$nonkeyidentity = Invoke-Sqlcmd @"
  with PrimaryKeyColumns as (
select kcu.COLUMN_NAME
  from INFORMATION_SCHEMA.TABLE_CONSTRAINTS as tc
  join INFORMATION_SCHEMA.KEY_COLUMN_USAGE as kcu
    on kcu.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA
   and kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
   and kcu.TABLE_SCHEMA = tc.TABLE_SCHEMA
   and kcu.TABLE_NAME = tc.TABLE_NAME
 where tc.TABLE_SCHEMA = $schemaname
   and tc.TABLE_NAME = $tablename
   and tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
)
select quotename(c.COLUMN_NAME) as COLUMN_NAME
  from INFORMATION_SCHEMA.COLUMNS c
 where c.TABLE_SCHEMA = $schemaname
   and c.TABLE_NAME = $tablename
   and c.COLUMN_NAME not in (select COLUMN_NAME from PrimaryKeyColumns)
   and columnproperty(object_id(c.TABLE_NAME), c.COLUMN_NAME,'IsIdentity') = 1;
"@ |% COLUMN_NAME
if($nonkeyidentity)
{
    Write-Verbose "Non-primary-key identity column detected: $nonkeyidentity"
    if($UseIdentityInKey) {$pk += $nonkeyidentity}
    else
    {
        Write-Warning @"
Non-key IDENTITY column $nonkeyidentity cannot be updated and will be ignored.
Specify -UseIdentityInKey to include it in the primary key.
"@
    }
}
Write-Verbose "Primary key: $pk"
$pkjoin = ($pk |% {"source.{0} = target.{0}" -f $_}) -join ' AND '

$data = Invoke-Sqlcmd "select * from $fqtn"
if(!$data) {throw "No data in table."}
$columns = Invoke-Sqlcmd @"
select quotename(COLUMN_NAME) as COLUMN_NAME
  from INFORMATION_SCHEMA.COLUMNS
 where TABLE_SCHEMA = $schemaname
   and TABLE_NAME = $tablename
 order by ORDINAL_POSITION;
"@ |% COLUMN_NAME
$dataupdates = ($columns |? {$_ -notin $pk} |% {"{0} = source.{0}" -f $_}) -join ",$([environment]::NewLine)"
$dataupdates =
    if($dataupdates) {"when matched then${EOL}update set $dataupdates"}
    else {"-- skip 'matched' condition (no non-key columns to update)"}
$targetlist = $columns -join ','
$sourcelist = ($columns |% {"source.{0}" -f $_}) -join ','

$data = ($data |% {($_.ItemArray |% {Format-SqlValue $_}) -join ','} |% {"($_)"}) -join ",$([environment]::NewLine)"

@"
if exists (select * from information_schema.columns where table_schema = $schemaname and table_name = $tablename
and columnproperty(object_id(table_name), column_name,'IsIdentity') = 1)
set identity_insert $fqtn on;

merge $fqtn as target
using ( values
$data
) as source ($targetlist)
on $pkjoin
$dataupdates
when not matched by target then
insert ($targetlist)
values ($sourcelist)
when not matched by source then delete ;

if exists (select * from information_schema.columns where table_schema = $schemaname and table_name = $tablename
and columnproperty(object_id(table_name), column_name,'IsIdentity') = 1)
set identity_insert $fqtn off;
"@
