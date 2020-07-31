<#
.Synopsis
    Searches for database columns.

.Parameter ServerInstance
    The server and instance to connect to.

.Parameter Database
    The database to use.

.Parameter IncludeSchemata
    A like-pattern of database schemata to include (will only include these).

.Parameter ExcludeSchemata
    A like-pattern of database schemata to exclude.

.Parameter IncludeTables
    A like-pattern of database tables to include (will only include these).

.Parameter ExcludeTables
    A like-pattern of database tables to exclude.

.Parameter IncludeColumns
    A like-pattern of database columns to include (will only include these).

.Parameter ExcludeColumns
	A like-pattern of database columns to exclude.

.Parameter DataType
	The basic datatype to search for.

.Parameter MinLength
	The minimum character column length.

.Parameter MaxLength
	The maximum character column length.

.Outputs
	System.Management.Automation.PSCustomObject for each found column:

	* TableSchema
	* TableName
	* ColumnName
	* DataType
	* Nullable
	* DefaultValue

.Component
    System.Configuration

.Link
    ConvertFrom-DataRow.ps1

.Link
    Stop-ThrowError.ps1

.Link
	Invoke-Sqlcmd

.Example
	Find-DbColumn.ps1 -ServerInstance '(localdb)\ProjectsV13' -Database AdventureWorks2016 -IncludeColumns %price% |Format-Table -AutoSize

	TableSchema TableName               ColumnName        DataType Nullable DefaultValue
	----------- ---------               ----------        -------- -------- ------------
	Production  Product                 ListPrice         money       False
	Production  ProductListPriceHistory ListPrice         money       False
	Purchasing  ProductVendor           StandardPrice     money       False
	Purchasing  PurchaseOrderDetail     UnitPrice         money       False
	Sales       SalesOrderDetail        UnitPrice         money       False
	Sales       SalesOrderDetail        UnitPriceDiscount money       False ((0.0))
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Management.Automation.PSCustomObject])] Param(
[Parameter(ParameterSetName='ByConnectionParameters',Mandatory=$true)][string] $ServerInstance,
[Parameter(ParameterSetName='ByConnectionParameters',Mandatory=$true)][string] $Database,
[Parameter(ParameterSetName='ByConnectionString',Mandatory=$true)][Alias('ConnStr','CS')][string] $ConnectionString,
[Parameter(ParameterSetName='ByConnectionName',Mandatory=$true)][string] $ConnectionName,
[string[]] $IncludeSchemata,
[string[]] $ExcludeSchemata,
[string[]] $IncludeTables,
[string[]] $ExcludeTables,
[string[]] $IncludeColumns,
[string[]] $ExcludeColumns,
[ValidateSet('char','byte','int','long','decimal','double','date','datetime','time')]
[string] $DataType,
[int] $MinLength,
[int] $MaxLength
)
try{[void][Configuration.ConfigurationManager]}catch{Add-Type -AssemblyName System.Configuration}
function Format-LikeCondition([string]$column,[string[]]$patterns,[switch]$not)
{
    $like,$andOr = if($not){'not like','and'}else{'like','or'}
@"

   and ( $(($patterns |% {"$column $like '$($_ -replace '''','''''')' escape '\'"}) -join " $andOr ") )

"@
}

Use-SqlcmdParams.ps1 -QueryTimeout 300

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
Invoke-Sqlcmd $colssql |ConvertFrom-DataRow.ps1
