<#
.Synopsis
    Searches an entire database for a field value.

.Parameter ServerInstance
    The server and instance to connect to.

.Parameter Database
    The database to use.

.Parameter Value
    The value to search for. The datatype is significant, e.g. searching for money/smallmoney columns, cast the type to decimal: [decimal]13.55
    Searches, by type:
      * string: varchar, char, nvarchar, nchar (char length must be at least as long as value)
      * byte: tinyint
      * int: bigint, int
      * long: bigint, numeric or decimal (where scale is zero)
      * decimal: money, smallmoney
      * double or float: float, real, numeric, decimal
      * datetime: date (if no time specified), datetime, datetime2, datetimeoffset, smalldatetime
      * timespan: time
    If the -LikeValue switch is specified, the type of value is assumed to be string.

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

.Parameter MinRows
    Tables with more rows than this value will be skipped.

.Parameter MaxRows
    Tables with more rows than this value will be skipped.

.Parameter FindFirst
    Quit as soon as the first value is found.

.Parameter LikeValue
    Interpret the value as a like-pattern (% for zero-or-more characters, _ for a single character, \ is escape).

.Component
    System.Configuration

.Link
    ConvertFrom-DataRow.ps1

.Link
    Stop-ThrowError.ps1

.Link
    Invoke-Sqlcmd

.Example
    Find-DatabaseValue.ps1 FR -IncludeSchemata Sales -MaxRows 100 -ServerInstance '(localdb)\ProjectsV13' -Database AdventureWorks2016

    TableName         : [Sales].[SalesTerritory]
    TerritoryID       : 7
    Name              : France
    CountryRegionCode : FR
    Group             : Europe
    SalesYTD          : 4772398.3078
    SalesLastYear     : 2396539.7601
    CostYTD           : 0.0000
    CostLastYear      : 0.0000
    rowguid           : bf806804-9b4c-4b07-9d19-706f2e689552
    ModifiedDate      : 04/30/2008 00:00:00

.Example
    Find-DatabaseValue.ps1 41636 -IncludeColumns %OrderID -ServerInstance '(localdb)\ProjectsV13' -Database AdventureWorks2016 |tee order41636.txt

    TableName            : [Production].[TransactionHistory]
    TransactionID        : 100046
    ProductID            : 826
    ReferenceOrderID     : 41636
    ReferenceOrderLineID : 0
    TransactionDate      : 07/31/2013 00:00:00
    TransactionType      : W
    Quantity             : 4
    ActualCost           : 0.0000
    ModifiedDate         : 07/31/2013 00:00:00

    TableName     : [Production].[WorkOrder]
    WorkOrderID   : 41636
    ProductID     : 826
    OrderQty      : 4
    StockedQty    : 4
    ScrappedQty   : 0
    StartDate     : 07/31/2013 00:00:00
    EndDate       : 08/11/2013 00:00:00
    DueDate       : 08/11/2013 00:00:00
    ScrapReasonID :
    ModifiedDate  : 08/11/2013 00:00:00

    TableName          : [Production].[WorkOrderRouting]
    WorkOrderID        : 41636
    ProductID          : 826
    OperationSequence  : 6
    LocationID         : 50
    ScheduledStartDate : 07/31/2013 00:00:00
    ScheduledEndDate   : 08/11/2013 00:00:00
    ActualStartDate    : 08/01/2013 00:00:00
    ActualEndDate      : 08/11/2013 00:00:00
    ActualResourceHrs  : 3.0000
    PlannedCost        : 36.7500
    ActualCost         : 36.7500
    ModifiedDate       : 08/11/2013 00:00:00
#>

#requires -version 2
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)] $Value,
[Parameter(ParameterSetName='ByConnectionParameters',Mandatory=$true)][string] $ServerInstance,
[Parameter(ParameterSetName='ByConnectionParameters',Mandatory=$true)][string] $Database,
[Parameter(ParameterSetName='ByConnectionString',Mandatory=$true)][Alias('ConnStr','CS')][string]$ConnectionString,
[Parameter(ParameterSetName='ByConnectionName',Mandatory=$true)][string]$ConnectionName,
[string[]] $IncludeSchemata,
[string[]] $ExcludeSchemata,
[string[]] $IncludeTables,
[string[]] $ExcludeTables,
[string[]] $IncludeColumns,
[string[]] $ExcludeColumns,
[int] $MinRows = 1,
[int] $MaxRows,
[switch] $FindFirst,
[switch] $LikeValue
)
try{[void][Configuration.ConfigurationManager]}catch{Add-Type -AssemblyName System.Configuration}
function ConvertTo-Filename([string]$s)
{
    $s = $s -replace '\\','-'
    $s = $s -replace '\[|\]',''
    foreach($c in [IO.Path]::GetInvalidFileNameChars()){$s = $s -replace "\$c",''};
    $s
}
function Format-LikeCondition([string]$column,[string[]]$patterns,[switch]$not)
{
    $like,$andOr = if($not){'not like','and'}else{'like','or'}
@"

   and ( $(($patterns |% {"$column $like '$($_ -replace '''','''''')' escape '\'"}) -join " $andOr ") )

"@
}

Use-SqlcmdParams.ps1 -QueryTimeout 300

$selectFrom = "select '{0}.{1}' [TableName], * from"
$colssql = @"
select quotename(TABLE_SCHEMA) TABLE_SCHEMA,
       quotename(TABLE_NAME) TABLE_NAME,
       quotename(COLUMN_NAME) COLUMN_NAME
  from INFORMATION_SCHEMA.COLUMNS

"@
if($LikeValue)
{
    $minLength = ($Value -replace '\\.','_' -replace '%','').Length
    Write-Verbose "Searching for character data with a minimum length of $minLength to match pattern."
    $colssql += @"
 where DATA_TYPE in ('varchar','char','nvarchar','nchar')
   and (CHARACTER_MAXIMUM_LENGTH = -1 or CHARACTER_MAXIMUM_LENGTH >= $minLength)
"@
    $valsql = "$selectFrom {0}.{1} where {2} like '$($Value -replace '''','''''')' escape '\';"
}
elseif($Value -is [string])
{
    Write-Verbose "Searching for character data with a minimum length of $($Value.Length)."
    $colssql += @"
 where DATA_TYPE in ('varchar','char','nvarchar','nchar')
   and (CHARACTER_MAXIMUM_LENGTH = -1 or CHARACTER_MAXIMUM_LENGTH >= $($Value.Length))
"@
    $valsql = "$selectFrom {0}.{1} where {2} = '$($Value -replace '''','''''')';"
}
elseif($Value -is [byte])
{
    Write-Verbose "Searching for byte (tinyint) data."
    $colssql += @"
 where DATA_TYPE in ('tinyint')
"@
    $valsql = "$selectFrom {0}.{1} where {2} = $Value;"
}
elseif($Value -is [int])
{
    Write-Verbose "Searching for integer data."
    $colssql += @"
 where DATA_TYPE in ('int')
"@
    $valsql = "$selectFrom {0}.{1} where {2} = $Value;"
}
elseif($Value -is [long])
{
    Write-Verbose "Searching for long integer data."
    $colssql += @"
 where (DATA_TYPE = 'bigint'
    or (DATA_TYPE in ('numeric','decimal') and NUMERIC_SCALE = 0))
"@
    $valsql = "$selectFrom {0}.{1} where {2} = '$Value';"
}
elseif($Value -is [decimal])
{
    Write-Verbose "Searching for decimal (money) data."
    $colssql += @"
 where DATA_TYPE in ('money','smallmoney')
"@
    $valsql = "$selectFrom {0}.{1} where {2} = $Value;"
}
elseif($Value -is [double] -or $Value -is [float])
{
    Write-Verbose "Searching for double-precision floating-point or money data."
    $colssql += @"
 where DATA_TYPE in ('float','real','numeric','decimal')
"@
    $valsql = "$selectFrom {0}.{1} where {2} = $Value;"
}
elseif($Value -is [datetime] -and $Value.TimeOfDay -eq 0)
{
    Write-Verbose "Searching for date data."
    $colssql += @"
 where DATA_TYPE in ('date','datetime','datetime2','datetimeoffset','smalldatetime')
"@
    $valsql = "$selectFrom {0}.{1} where {2} = '$($Value.ToString('yyyy-MM-dd'))';"
}
elseif($Value -is [datetime])
{
    Write-Verbose "Searching for datetime data."
    $colssql += @"
 where DATA_TYPE in ('datetime','datetime2','datetimeoffset','smalldatetime')
"@
    $valsql = "$selectFrom {0}.{1} where {2} = '$($Value.ToString('u'))';"
}
elseif($Value -is [timespan])
{
    Write-Verbose "Searching for time data."
    $colssql += @"
 where DATA_TYPE in ('time')
"@
    $valsql = "$selectFrom {0}.{1} where {2} = '$($Value.ToString('HH:mm:ss.fffff'))';"
}
if($IncludeSchemata) { $colssql += Format-LikeCondition TABLE_SCHEMA $IncludeSchemata }
if($ExcludeSchemata) { $colssql += Format-LikeCondition TABLE_SCHEMA $ExcludeSchemata -Not }
if($IncludeTables) { $colssql += Format-LikeCondition TABLE_NAME $IncludeTables }
if($ExcludeTables) { $colssql += Format-LikeCondition TABLE_NAME $ExcludeTables -Not }
if($IncludeColumns) { $colssql += Format-LikeCondition COLUMN_NAME $IncludeColumns }
if($ExcludeColumns) { $colssql += Format-LikeCondition COLUMN_NAME $ExcludeColumns -Not }
$colssql += ' order by TABLE_SCHEMA, TABLE_NAME, ORDINAL_POSITION;'

Write-Debug "Schema Query:`n$colssql"
$corpus = Invoke-Sqlcmd $colssql |ConvertFrom-DataRow.ps1
if(!$corpus) {Stop-ThrowError.ps1 ItemNotFoundException 'No columns left to search.' ObjectNotFound $PSBoundParameters NOCOLS}
Write-Verbose "Searching $($corpus.Length) tables"
$count,$p,$rows,$lasttable = 0,0,0,''
foreach($row in $corpus)
{
    Import-Variables.ps1 $row
    if($lasttable -ne "$TABLE_SCHEMA.$TABLE_NAME")
    {
        [int]$rows = Invoke-Sqlcmd "select count(*) rows from $TABLE_SCHEMA.$TABLE_NAME" |ConvertFrom-DataRow.ps1 -AsValues
        $lasttable = "$TABLE_SCHEMA.$TABLE_NAME"
    }
    Write-Progress 'Searching columns' "$TABLE_SCHEMA.$TABLE_NAME.$COLUMN_NAME" 1 -CurrentOperation "$rows rows" `
        -PercentComplete ((++$p)*100/$corpus.Length) -ErrorAction SilentlyContinue
    if($rows -lt $MinRows) {Write-Verbose "Skipping $TABLE_SCHEMA.$TABLE_NAME ($rows rows < $MinRows)"; continue}
    if($MaxRows -and $rows -gt $MaxRows) {Write-Verbose "Skipping $TABLE_SCHEMA.$TABLE_NAME ($rows rows > $MaxRows)"; continue}
    $query = $valsql -f $TABLE_SCHEMA,$TABLE_NAME,$COLUMN_NAME
    [Data.DataTable]$data = $null
    Write-Verbose "Query: $query"
    $data = Invoke-Sqlcmd $query -OutputAs DataTables
    if($data -and ($data.Rows.Count -gt 0))
    {
        $count += $data.Rows.Count
        Write-Verbose "Found $($data.Rows.Count) rows in $TABLE_SCHEMA.$TABLE_NAME."
        $data.Rows |ConvertFrom-DataRow.ps1
        if($FindFirst) { break }
    }
}
if(!$count) {Write-Warning "No rows found."}
else {Write-Verbose "Found $count total rows."}
