<#
.Synopsis
    Returns indexes using a column with the given name.

.Parameter ServerInstance
    The name of a server (and optional instance) to connect and use for the query.
    May be used with optional Database, Credential, and ConnectionProperties parameters.

.Parameter Database
    The the database to connect to on the server.

.Parameter ConnectionString
    Specifies a connection string to connect to the server.

.Parameter ConnectionName
    The connection string name from the ConfigurationManager to use.

.Parameter ColumnName
    The column name to search for.

.Link
    Invoke-Sqlcmd

.Link
    ConvertFrom-DataRow.ps1

.Link
    https://docs.microsoft.com/sql/relational-databases/system-catalog-views/sys-index-columns-transact-sql

.Example
    Find-Indexes.ps1 -ServerInstance '(localdb)\ProjectsV13' -Database AdventureWorks -ColumnName AddressTypeID

    SchemaName   : Person
    TableName    : AddressType
    IndexName    : AddressTypePK
    IndexOrdinal : 1
    IsUnique     : 1
    IsClustered  : 1
    IsDisabled   : 0
#>

#Requires -Version 3
#Requires -Module SqlServer
[CmdletBinding()][OutputType([string])] Param(
[Parameter(ParameterSetName='ByConnectionParameters',Position=0,Mandatory=$true)][string] $ServerInstance,
[Parameter(ParameterSetName='ByConnectionParameters',Position=1,Mandatory=$true)][string] $Database,
[Parameter(ParameterSetName='ByConnectionString',Mandatory=$true)][Alias('ConnStr','CS')][string]$ConnectionString,
[Parameter(ParameterSetName='ByConnectionName',Mandatory=$true)][string]$ConnectionName,
[Parameter(Position=2,Mandatory=$true)][Alias('ColName')][string]$ColumnName
)

Use-SqlcmdParams.ps1

Invoke-Sqlcmd @"
select object_schema_name(i.object_id) SchemaName,
       object_name(i.object_id) TableName,
       i.name IndexName,
       ic.index_column_id IndexOrdinal,
       indexproperty(i.object_id,i.name,'IsUnique') IsUnique,
       indexproperty(i.object_id,i.name,'IsClustered') IsClustered,
       indexproperty(i.object_id,i.name,'IsDisabled') IsDisabled,
       (select count(*) from sys.index_columns c where c.object_id = i.object_id and c.index_id = i.index_id) ColumnsInIndex
  from sys.index_columns ic
  join sys.indexes i
    on ic.object_id = i.object_id
   and ic.index_id = i.index_id
 where col_name(ic.object_id,ic.column_id) = '$($ColumnName -replace "'","''")'
 order by TableName, IndexName;
"@ |ConvertFrom-DataRow.ps1
