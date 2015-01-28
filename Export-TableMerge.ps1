<#
.Synopsis
Exports table data as a T-SQL MERGE statement.
.Parameter Connection
A DbConnection object used for the query.
.Parameter ConnectionName
The name of a connection string from the ConfigurationManager's ConnectionStrings,
used to create a connection for the query.
.Parameter Server
The name of a server (and optional instance) to connect and use for the query.
May be used with optional Database, Credential, and ConnectionProperties parameters.
.Parameter Database
The the database to connect to on the server.
.Parameter Credential
The credential to use when connecting to the server.
If no credential is specified, a trusted connection is used.
.Parameter ConnectionProperties
Additional connection properties to use when connecting to the server, such as Timeout.
.Parameter ConnectionString
A complete connection string to create a connection to use for the query.
.Parameter ProviderName
The database provider to use. System.Data.SqlClient by default.
.Parameter Schema
The name of the table's schema.
.Parameter Table
The name of the table to export.
.Example
Export-TableMerge -ConnectionName pubs -Table authors |Out-File authors.sql
.Example
Export-TableMerge $conn -Table employee |Out-File employee.sql
.Example
Export-TableMerge -Server "(localdb)\ProjectV12" -Database AdventureWorks2014 -Schema Production -Table Product |Out-File -Encoding utf8 Data\Production.Product.sql
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(ParameterSetName='Connection',Position=0,Mandatory=$true)]
[Data.Common.DbConnection]$Connection,
[Parameter(ParameterSetName='ConnectionName',Position=0,Mandatory=$true)]
[Alias('Name','N')][string]$ConnectionName,
[Parameter(ParameterSetName='Server',Position=0,Mandatory=$true)]
[Alias('ComputerName','CN','S')][string]$Server,
[Parameter(ParameterSetName='Server',Position=1)][Alias('D')][string]$Database,
[Parameter(ParameterSetName='Server')][PSCredential]$Credential,
[Parameter(ParameterSetName='Server')]
[Alias('ConnProps','CP')][Collections.Hashtable]$ConnectionProperties = @{},
[Parameter(ParameterSetName='ConnectionString',Position=0,Mandatory=$true)]
[Alias('CS')][string]$ConnectionString,
[Parameter(ParameterSetName='Server')]
[Parameter(ParameterSetName='ConnectionString')]
[string]$ProviderName = 'System.Data.SqlClient',
[Parameter(ParameterSetName='Connection')]
[Parameter(ParameterSetName='ConnectionName')]
[Parameter(ParameterSetName='Server')]
[Parameter(ParameterSetName='ConnectionString')]
[string]$Schema = 'dbo',
[Parameter(ParameterSetName='Connection',Mandatory=$true)]
[Parameter(ParameterSetName='ConnectionName')]
[Parameter(ParameterSetName='Server')]
[Parameter(ParameterSetName='ConnectionString')]
[string]$Table
)
Add-Type -AN System.Configuration
Add-Type -AN System.Data

$tempconn = !$Connection
if($tempconn)
{
    $Connection =
        if($ConnectionName)
        {
            Connect-Database.ps1 -ConnectionName $ConnectionName
            $ProviderName = [Configuration.ConfigurationManager]::ConnectionStrings[$ConnectionName].ProviderName
        }
        elseif($ConnectionString)
        {
            Connect-Database.ps1 -ConnectionString $ConnectionString -ProviderName $ProviderName
        }
        else
        {
            $connargs = @{Server=$Server}
            if($Database) {$connargs.Add('Database',$Database)}
            if($Database) {$connargs.Add('Credential',$Credential)}
            if($Database) {$connargs.Add('Properties',$ConnectionProperties)}
            Connect-Database.ps1 @connargs
        }
}
$cb = [Data.Common.DbProviderFactories]::GetFactory($ProviderName).CreateCommandBuilder()
$fqtn = '{0}.{1}' -f $cb.QuoteIdentifier($Schema),$cb.QuoteIdentifier($Table)
$schemaname = "'" + ($Schema -replace "'","''") + "'"
$tablename = "'" + ($Table -replace "'","''") + "'"

$pk = Invoke-DbCommand.ps1 $Connection -params @{schema=$Schema;table=$Table} -q @'
select kcu.COLUMN_NAME
  from INFORMATION_SCHEMA.TABLE_CONSTRAINTS as tc
  join INFORMATION_SCHEMA.KEY_COLUMN_USAGE as kcu
    on kcu.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA
   and kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
   and kcu.TABLE_SCHEMA = tc.TABLE_SCHEMA
   and kcu.TABLE_NAME = tc.TABLE_NAME
 where tc.TABLE_SCHEMA = @schema
   and tc.TABLE_NAME = @table
   and tc.CONSTRAINT_TYPE = 'PRIMARY KEY' -- UNIQUE?
 order by kcu.ORDINAL_POSITION;
'@ |% {$cb.QuoteIdentifier($_.COLUMN_NAME)}
Write-Verbose "Primary key: $pk"
$pkjoin = ($pk |% {"source.{0} = target.{0}" -f $_}) -join ' AND '

$data = Invoke-DbCommand.ps1 $Connection -q "select * from $fqtn"
if($tempconn) {Disconnect-Database.ps1 $Connection}
if(!$data) {Write-Warning "No data in table."; return}
$columns = $data[0].Table.Columns |% {$cb.QuoteIdentifier($_.ColumnName)}
$dataupdates = ($columns |? {$pk -notcontains $_} |% {"{0} = source.{0}" -f $_}) -join ",`n"
$targetlist = $columns -join ','
$sourcelist = ($columns |% {"source.{0}" -f $_}) -join ','

function Format-SqlValue($value)
{
    if($value -is [DBNull]) {'null'}
    elseif($value -is [string]) {"'{0}'" -f ($value -replace "'","''")}
    elseif($value -is [datetime]) {"'{0}'" -f $value} # hmm… format? type?
    elseif($value -is [bool]) {if($value){1}else{0}}
    elseif($value -is [guid]) {"'{0}'" -f $value}
    else {$value}
}
$data = ($data |% {($_.ItemArray |% {Format-SqlValue $_}) -join ','} |% {"($_)"}) -join ",`n"

@"
if exists (select * from information_schema.columns where table_schema = $schemaname and table_name = $tablename
and columnproperty(object_id(table_name), column_name,'IsIdentity') = 1)
set identity_insert $fqtn on;

merge $fqtn as target
using ( values
$data
) as source ($targetlist)
on $pkjoin
when matched then
update set $dataupdates
when not matched by target then
insert ($targetlist)
values ($sourcelist)
when not matched by source then delete ;

if exists (select * from information_schema.columns where table_schema = $schemaname and table_name = $tablename
and columnproperty(object_id(table_name), column_name,'IsIdentity') = 1)
set identity_insert $fqtn off;
"@
