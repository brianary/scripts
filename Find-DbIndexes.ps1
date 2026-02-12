<#
.SYNOPSIS
Returns indexes using a column with the given name.

.OUTPUTS
System.Management.Automation.PSCustomObject with these properties:

* SchemaName
* TableName
* IndexName
* IndexOrdinal
* IsUnique
* IsClustered
* IsDisabled
* ColumnsInIndex

.FUNCTIONALITY
Database

.LINK
https://docs.microsoft.com/sql/relational-databases/system-catalog-views/sys-index-columns-transact-sql

.LINK
https://dbatools.io/

.LINK
Invoke-DbaQuery

.EXAMPLE
Find-DbIndexes.ps1 -SqlInstance '(localdb)\ProjectsV13' -Database AdventureWorks2014 -ColumnName ErrorLogID

SchemaName     : dbo
TableName      : ErrorLog
IndexName      : PK_ErrorLog_ErrorLogID
IndexOrdinal   : 1
IsUnique       : True
IsClustered    : True
IsDisabled     : False
ColumnsInIndex : 1
#>

#Requires -Version 7
using module dbatools
using namespace Microsoft.SqlServer.Management.Smo
[CmdletBinding()][OutputType([pscustomobject])] Param(
# The server to use, by name or constructed via Connect-DbaInstance.
[Parameter(Position=0,Mandatory=$true)][Alias('Parent','ServerInstance')][DbaInstanceParameter] $SqlInstance,
# The the database to connect to on the server.
[Parameter(Position=1)][Alias('Name')][string] $Database,
# The column name to search for.
[Parameter(Position=2,Mandatory=$true)][Alias('ColName')][string] $ColumnName
)
Process
{
	Use-DbInstance.ps1 -As PSObject
	return Invoke-DbaQuery -Query @"
select object_schema_name(i.object_id) SchemaName,
       object_name(i.object_id) TableName,
       i.name IndexName,
       ic.index_column_id IndexOrdinal,
       cast(indexproperty(i.object_id,i.name,'IsUnique') as bit) IsUnique,
       cast(indexproperty(i.object_id,i.name,'IsClustered') as bit) IsClustered,
       cast(indexproperty(i.object_id,i.name,'IsDisabled') as bit) IsDisabled,
       (select count(*) from sys.index_columns c where c.object_id = i.object_id and c.index_id = i.index_id) ColumnsInIndex
  from sys.index_columns ic
  join sys.indexes i
    on ic.object_id = i.object_id
   and ic.index_id = i.index_id
 where col_name(ic.object_id,ic.column_id) = '$($ColumnName -replace "'","''")'
 order by TableName, IndexName;
"@
}
