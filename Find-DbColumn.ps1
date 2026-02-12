<#
.SYNOPSIS
Searches for database columns.

.OUTPUTS
System.Management.Automation.PSCustomObject for each found column:

* TableSchema
* TableName
* ColumnName
* DataType
* Nullable
* DefaultValue

.FUNCTIONALITY
Database

.LINK
https://dbatools.io/

.LINK
Invoke-DbaQuery

.LINK
Stop-ThrowError.ps1

.EXAMPLE
Find-DbColumn.ps1 -SqlInstance '(localdb)\ProjectsV13' -Database AdventureWorks2016 -IncludeColumns %price% |Format-Table -AutoSize

TableSchema TableName        ColumnName        DataType Nullable DefaultValue
----------- ---------        ----------        -------- -------- ------------
SalesLT     Product          ListPrice         money       False
SalesLT     SalesOrderDetail UnitPrice         money       False
SalesLT     SalesOrderDetail UnitPriceDiscount money       False ((0.0))
#>

#Requires -Version 7
using module dbatools
[CmdletBinding()][OutputType([Management.Automation.PSCustomObject])] Param(
# The server to use, by name or constructed via Connect-DbaInstance.
[Parameter(Position=0,Mandatory=$true)][Alias('Parent','ServerInstance')][DbaInstanceParameter] $SqlInstance,
# The the database to connect to on the server.
[Parameter(Position=1)][Alias('Name')][string] $Database,
# A like-pattern of database schemata to include (will only include these).
[string[]] $IncludeSchemata,
# A like-pattern of database schemata to exclude.
[string[]] $ExcludeSchemata,
# A like-pattern of database tables to include (will only include these).
[string[]] $IncludeTables,
# A like-pattern of database tables to exclude.
[string[]] $ExcludeTables,
# A like-pattern of database columns to include (will only include these).
[string[]] $IncludeColumns,
# A like-pattern of database columns to exclude.
[string[]] $ExcludeColumns,
# The basic datatype to search for.
[ValidateSet('char','byte','int','long','decimal','double','date','datetime','time')]
[string] $DataType,
# The minimum character column length.
[int] $MinLength,
# The maximum character column length.
[int] $MaxLength
)
Use-DbInstance.ps1 -As PSObject
function Format-LikeCondition([string]$column,[string[]]$patterns,[switch]$not)
{
	$like,$andOr = if($not){'not like','and'}else{'like','or'}
@"

   and ( $(($patterns |ForEach-Object {"$column $like '$($_ -replace '''','''''')' escape '\'"}) -join " $andOr ") )

"@
}

$colssql = @"
select TABLE_SCHEMA TableSchema,
       TABLE_NAME TableName,
       COLUMN_NAME ColumnName,
       DATA_TYPE +
       case
       when DATA_TYPE in ('int','smallint','bigint','tinyint','money','bit') then ''
       when CHARACTER_MAXIMUM_LENGTH is not null then '(' + cast(CHARACTER_MAXIMUM_LENGTH as varchar) + ')'
       when NUMERIC_PRECISION is not null then '(' + cast(NUMERIC_PRECISION as varchar) +
            case when NUMERIC_PRECISION_RADIX is not null and NUMERIC_PRECISION_RADIX <> 10 then ' base ' +
                 cast(NUMERIC_PRECISION_RADIX as varchar) else '' end +
                 case when NUMERIC_SCALE is not null then ',' + cast(NUMERIC_SCALE as varchar) else '' end + ')'
       else ''
       end DataType,
       cast(case IS_NULLABLE when 'Yes' then 1 else 0 end as bit) Nullable,
       COLUMN_DEFAULT DefaultValue
  from INFORMATION_SCHEMA.COLUMNS

"@
$colssql += switch($DataType)
{
	string {@"
 where DATA_TYPE in ('varchar','char','nvarchar','nchar')
$(if($MinLength){"   and (CHARACTER_MAXIMUM_LENGTH = -1 or CHARACTER_MAXIMUM_LENGTH >= $MinLength)"})
$(if($MaxLength){"   and (CHARACTER_MAXIMUM_LENGTH = -1 or CHARACTER_MAXIMUM_LENGTH >= $MaxLength)"})
"@}
	byte {@"
 where DATA_TYPE in ('tinyint')
"@}
	int {@"
 where DATA_TYPE in ('int')
"@}
	long {@"
 where (DATA_TYPE = 'bigint'
    or (DATA_TYPE in ('numeric','decimal') and NUMERIC_SCALE = 0))
"@}
	decimal {@"
 where DATA_TYPE in ('money','smallmoney')
"@}
	{$_ -in 'float','double'} {@"
 where DATA_TYPE in ('float','real','numeric','decimal')
"@}
	date {@"
 where DATA_TYPE in ('date','datetime','datetime2','datetimeoffset','smalldatetime')
"@}
	datetime {@"
 where DATA_TYPE in ('datetime','datetime2','datetimeoffset','smalldatetime')
"@}
	time {@"
 where DATA_TYPE in ('time')
"@}
	default {@"
 where 1 = 1
"@}
}
if($IncludeSchemata) { $colssql += Format-LikeCondition TABLE_SCHEMA $IncludeSchemata }
if($ExcludeSchemata) { $colssql += Format-LikeCondition TABLE_SCHEMA $ExcludeSchemata -Not }
if($IncludeTables) { $colssql += Format-LikeCondition TABLE_NAME $IncludeTables }
if($ExcludeTables) { $colssql += Format-LikeCondition TABLE_NAME $ExcludeTables -Not }
if($IncludeColumns) { $colssql += Format-LikeCondition COLUMN_NAME $IncludeColumns }
if($ExcludeColumns) { $colssql += Format-LikeCondition COLUMN_NAME $ExcludeColumns -Not }
$colssql += ' order by TABLE_SCHEMA, TABLE_NAME, ORDINAL_POSITION;'

Write-Debug "Schema Query:`n$colssql"
Invoke-DbaQuery -Query $colssql
