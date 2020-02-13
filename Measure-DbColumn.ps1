<#
.Synopsis
    Provides statistics about SQL Server column data.

.Parameter Column
    An SMO column object associated to the database column to examine.

.Parameter ColumnName
    The name of the column to examine in the table associated with the SMO Table object.

.Parameter Table
    An SMO table object associated to the database to examine.

.Parameter Condition
    Conditions to be provided as a SQL WHERE clause to filter the column values to examine.
    Useful for databases that implement "soft deletes" as specific field values.

.Inputs
    Microsoft.SqlServer.Management.Smo.Column to calculate statistics for,
    or Microsoft.SqlServer.Management.Smo.Table to select a column from by name.

.Link
    https://www.powershellgallery.com/packages/SqlServer/

.Link
    https://dbatools.io/

.Link
    https://wikipedia.org/wiki/Windows1252

.Example
    $table = Get-DbaDbTable SqlServerName -Database DbName -Table TableName; Measure-DbColumn.ps1 $table.Columns['record_id']

    ColumnName        : record_id
    SqlType           : int
    NullValues        : 0
    IsUnique          : True
    UniqueValues      : 43
    MinimumValue      : 2
    MaximumValue      : 56
    MeanAverage       : 28
    ModeAverage       : 28
    Variance          : 290.330011074197
    StandardDeviation : 17.0390730696889

.Example
    Get-DbaDbTable SqlServerName -Database DbName -Table TableName |Measure-DbColumn.ps1 surname

    ColumnName         : surname
    SqlType            : varchar(40)
    NullValues         : 0
    IsUnique           : False
    UniqueValues       : 72281
    MinimumValue       :  AARONSON
    MaximumValue       : ZYKOWSKI
    MostCommonValue    : SMITH
    MininumLength      : 1
    MaximumLength      : 40
    HasLeadingSpaces   : True
    HasTrailingSpaces  : False
    HasControlChars    : False
    HasWindows1252     : False
    HasUnicode         : False
    HasNonAscii7       : False
    HasNonAlphanumeric : True

.Example
    Get-DbaDbTable '(localdb)\ProjectsV13' -database AdventureWorks2016 -Table Sales.SalesOrderHeader |Measure-DbColumn.ps1 OrderDate

    ColumnName      : OrderDate
    SqlType         : datetime
    Values          : 31465
    NullValues      : 0
    IsUnique        : False
    IsDateOnly      : True
    DateOnlyValues  : 31465
    DateTimeValues  : 0
    UniqueValues    : 1124
    MostCommonValue : 03/31/2014 00:00:00
    MinimumValue    : 05/31/2011 00:00:00
    MaximumValue    : 06/30/2014 00:00:00
    ModeAverage     : 03/31/2014 00:00:00
    MeanYear        : 2013
    ModeYear        : 2013
    MeanMonth       : January
    ModeMonth       : May
    MeanDayOfWeek   : Thursday
    ModeDayOfWeek   : Monday
    MeanDayOfMonth  : 16
    Sunday          : 4444
    Monday          : 4875
    Tuesday         : 4482
    Wednesday       : 4591
    Thursday        : 4346
    Friday          : 4244
    Saturday        : 4483
    January         : 2877
    Febuary         : 2300
    March           : 3144
    April           : 2812
    May             : 3175
    June            : 2189
    July            : 2356
    August          : 2324
    September       : 2300
    October         : 2616
    November        : 2716
    December        : 2656
#>

#Requires -Version 3
#Requires -Module SqlServer
[CmdletBinding(ConfirmImpact='Medium')] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ParameterSetName='Column')]
[Microsoft.SqlServer.Management.Smo.Column] $Column,
[Parameter(Position=0,Mandatory=$true,ParameterSetName='ColumnName')][string] $ColumnName,
[Parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true,ParameterSetName='ColumnName')]
[Microsoft.SqlServer.Management.Smo.Table] $Table,
[string] $Condition
)
Begin
{
    $SOQ = @'
select '{2}' ColumnName,
       '{3}' SqlType,
'@
    $EOQ = if(!$Condition) {' from [{0}].[{1}];'} else {" from [{0}].[{1}] where $Condition ;"}
    $query = @{
        Numeric = @"
  with TopValues as (
select top 1 with ties [{2}] value, count(*) #
  from [{0}].[{1}]
 group by [{2}]
 order by # desc
),     MedianValue as (
select max(value) value
  from (select top 50 percent [{2}] value from [{0}].[{1}] order by value) a
 union
select min(value)
  from (select top 50 percent [{2}] value from [{0}].[{1}] order by value desc) b
)
$SOQ
       count([{2}]) [Values],
       sum(case when [{2}] is null then 1 else 0 end) NullValues,
       cast(case when count(*) = count(distinct [{2}]) then 1 else 0 end as bit) IsUnique,
       count(distinct [{2}]) UniqueValues,
       min([{2}]) MinimumValue,
       max([{2}]) MaximumValue,
       avg(cast([{2}] as real)) MeanAverage,
       (select avg(cast(value as real)) from MedianValue) MedianAverage,
       (select avg(cast(value as real)) from TopValues) ModeAverage,
       var([{2}]) Variance,
       stdev([{2}]) StandardDeviation
$EOQ
"@
        DateTime = @"
  with TopValues as (
select top 1 [{2}] value, count(*) #
  from [{0}].[{1}]
 group by [{2}]
 order by # desc
),     MedianValue as (
select max(a.value) value
  from (select top 50 percent [{2}] value from [{0}].[{1}] order by value) a
 union
select min(b.value)
  from (select top 50 percent [{2}] value from [{0}].[{1}] order by value desc) b
),     DateOnlyCount as (
select count(*) #
  from [{0}].[{1}]
 where [{2}] = cast([{2}] as date)
),     TopYears as (
select top 1 Year([{2}]) [year], count(*) #
  from [{0}].[{1}]
 group by Year([{2}])
 order by # desc
),     TopMonths as (
select top 1 datename(month,[{2}]) [month], count(*) #
  from [{0}].[{1}]
 group by datename(month,[{2}])
 order by # desc
),     TopDaysOfWeek as (
select top 1 datename(dw,[{2}]) [dayofweek], count(*) #
  from [{0}].[{1}]
 group by datename(dw,[{2}])
 order by # desc
),     TopDays as (
select top 1 Day([{2}]) [day], count(*) #
  from [{0}].[{1}]
 group by Day([{2}])
 order by # desc
)
$SOQ
       count([{2}]) [Values],
       sum(case when [{2}] is null then 1 else 0 end) NullValues,
       cast(case when count(*) = count(distinct [{2}]) then 1 else 0 end as bit) IsUnique,
       cast(case count([{2}]) when (select # from DateOnlyCount) then 1 else 0 end as bit) IsDateOnly,
       (select # from DateOnlyCount) DateOnlyValues,
       count([{2}]) - (select # from DateOnlyCount) DateTimeValues,
       count(distinct [{2}]) UniqueValues,
       (select top 1 value from TopValues) MostCommonValue,
       min([{2}]) MinimumValue,
       max([{2}]) MaximumValue,
       --dateadd(seconds,'1970-01-01',avg(cast(datediff(second,'1970-01-01',[{2}]) as real))) MeanAverage,
       --(select dateadd(seconds,avg([{2}]),'1970-01-01') from TopValues) MedianAverage,
       (select value from TopValues) ModeAverage,
       cast(avg(cast(Year([{2}]) as real)) as int) MeanYear,
       (select [year] from TopYears) ModeYear,
       datename(month,avg(Month([{2}]))) MeanMonth,
       (select [month] from TopMonths) ModeMonth,
       datename(dw,avg(datepart(dw,[{2}]))) MeanDayOfWeek,
       (select [dayofweek] from TopDaysOfWeek) ModeDayOfWeek,
       avg(Day([{2}])) MeanDayOfMonth,
       sum(case datepart(dw,[{2}]) when 1 then 1 end) Sunday,
       sum(case datepart(dw,[{2}]) when 2 then 1 end) Monday,
       sum(case datepart(dw,[{2}]) when 3 then 1 end) Tuesday,
       sum(case datepart(dw,[{2}]) when 4 then 1 end) Wednesday,
       sum(case datepart(dw,[{2}]) when 5 then 1 end) Thursday,
       sum(case datepart(dw,[{2}]) when 6 then 1 end) Friday,
       sum(case datepart(dw,[{2}]) when 7 then 1 end) Saturday,
       sum(case datepart(m,[{2}]) when 1 then 1 end) January,
       sum(case datepart(m,[{2}]) when 2 then 1 end) Febuary,
       sum(case datepart(m,[{2}]) when 3 then 1 end) March,
       sum(case datepart(m,[{2}]) when 4 then 1 end) April,
       sum(case datepart(m,[{2}]) when 5 then 1 end) May,
       sum(case datepart(m,[{2}]) when 6 then 1 end) June,
       sum(case datepart(m,[{2}]) when 7 then 1 end) July,
       sum(case datepart(m,[{2}]) when 8 then 1 end) August,
       sum(case datepart(m,[{2}]) when 9 then 1 end) September,
       sum(case datepart(m,[{2}]) when 10 then 1 end) October,
       sum(case datepart(m,[{2}]) when 11 then 1 end) November,
       sum(case datepart(m,[{2}]) when 12 then 1 end) December
$EOQ
"@
        Temporal = @"
  with TopValues as (
select top 1 [{2}] value, count(*) #
  from [{0}].[{1}]
 group by [{2}]
 order by # desc
)
$SOQ
       count([{2}]) [Values],
       sum(case when [{2}] is null then 1 else 0 end) NullValues,
       cast(case when count(*) = count(distinct [{2}]) then 1 else 0 end as bit) IsUnique,
       count(distinct [{2}]) UniqueValues,
       (select top 1 value from TopValues) MostCommonValue,
       min([{2}]) MinimumValue,
       max([{2}]) MaximumValue
$EOQ
"@
        String = @"
  with TopValues as (
select top 1 [{2}] value, count(*) #
  from [{0}].[{1}]
 group by [{2}]
 order by # desc
)
$SOQ
       count([{2}]) [Values],
       sum(case when [{2}] is null then 1 else 0 end) NullValues,
       cast(case when count(*) = count(distinct [{2}]) then 1 else 0 end as bit) IsUnique,
       count(distinct [{2}]) UniqueValues,
       min([{2}]) MinimumValue,
       max([{2}]) MaximumValue,
       (select top 1 value from TopValues) MostCommonValue,
       min(len([{2}])) MininumLength,
       max(len([{2}])) MaximumLength,
       cast(case when exists (select top 1 * from [{0}].[{1}] where [{2}] <> ltrim([{2}])) then 1 else 0 end as bit) HasLeadingSpaces,
       cast(case when exists (select top 1 * from [{0}].[{1}] where [{2}] <> rtrim([{2}])) then 1 else 0 end as bit) HasTrailingSpaces,
       cast(case when exists (select top 1 * from [{0}].[{1}] where [{2}] like '%'+char(0x09)+'%') then 1 else 0 end as bit) HasTabs,
       cast(case when exists (select top 1 * from [{0}].[{1}] where [{2}]
           like '%[' + char(0x00) + '-' + char(0x1F) + ']%') then 1 else 0 end as bit) HasControlChars,
       cast(case when exists (select top 1 * from [{0}].[{1}] where [{2}]
           like '%[€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ]%') then 1 else 0 end as bit) HasWindows1252Conflicts,
       cast(case when exists (select top 1 * from [{0}].[{1}] where [{2}] collate SQL_Latin1_General_CP437_BIN
           <> cast([{2}] as varchar(max)) collate SQL_Latin1_General_CP437_BIN) then 1 else 0 end as bit) HasUnicode,
       cast(case when exists (select top 1 * from [{0}].[{1}] where [{2}] collate SQL_Latin1_General_CP437_BIN
           like '%[^' + char(0x00) + '-~]%') then 1 else 0 end as bit) HasNonAscii7,
       cast(case when exists (select top 1 * from [{0}].[{1}] where ltrim(rtrim([{2}])) like '%[^0-9A-Za-z_]%') then 1 else 0 end as bit) HasNonAlphanumeric
$EOQ
"@
        VariableLength = @"
$SOQ
       count([{2}]) [Values],
       sum(case when [{2}] is null then 1 else 0 end) NullValues,
       cast(case when count(*) = count(distinct [{2}]) then 1 else 0 end as bit) IsUnique,
       count(distinct [{2}]) UniqueValues,
       min(len([{2}])) MininumLength,
       max(len([{2}])) MaximumLength
$EOQ
"@
        Other = @"
$SOQ
       count([{2}]) Values,
       sum(case when [{2}] is null then 1 else 0 end) NullValues
$EOQ
"@
    }
    $typeinfo = @{
        bigint           = @('Numeric','{0}')
        binary           = @('VariableLength','{0}({1})')
        bit              = @('Other','{0}')
        char             = @('String','{0}({1})')
        cursor           = @('Other','{0}')
        date             = @('Temporal','{0}')
        datetime         = @('DateTime','{0}')
        datetime2        = @('DateTime','{0}({3})')
        datetimeoffset   = @('DateTime','{0}({3})')
        decimal          = @('Numeric','{0}({2},{3})')
        float            = @('Numeric','{0}')
        geography        = @('Other','{0}')
        geometry         = @('Other','{0}')
        hierarchyid      = @('Other','{0}')
        image            = @('Other','{0}')
        int              = @('Numeric','{0}')
        money            = @('Numeric','{0}')
        nchar            = @('String','{0}({1})')
        ntext            = @('Other','{0}')
        numeric          = @('Numeric','{0}({2},{3})')
        nvarchar         = @('String','{0}({1:0;max})')
        real             = @('Numeric','{0}')
        rowversion       = @('Other','{0}')
        smalldatetime    = @('DateTime','{0}')
        smallint         = @('Numeric','{0}')
        smallmoney       = @('Numeric','{0}')
        sql_variant      = @('VariableLength','{0}')
        table            = @('Other','{0}')
        text             = @('Other','{0}')
        time             = @('Temporal','{0}')
        tinyint          = @('Numeric','{0}')
        uniqueidentifier = @('Other','{0}')
        varbinary        = @('VariableLength','{0}({1:0;max})')
        varchar          = @('String','{0}({1:0;max})')
        xml              = @('VariableLength','{0}')
    }
}
Process
{
	if($Column) {$ColumnName = $Column.Name}
	else
	{
		$Column = $Table.Columns[$ColumnName]
		if(!$Column)
		{
			Stop-ThrowError.ps1 ArgumentException "Column '$ColumnName' not found in table '$($Table.Name)'",
				'ColumnName' InvalidArgument $Table 'NOCOL'
		}
	}
    $datatype = $Column.DataType
    $querytype,$typefmt = $typeinfo[$datatype.Name]
    $table = $Column.Parent
	$fqtn = "$($table.Parent.Parent.Name).$($table.Parent.Name).$($table.Name)"
	$sql = $query[$querytype] -f $table.Schema,$table.Name,$ColumnName,
		($typefmt -f $datatype.Name,$datatype.MaximumLength,$datatype.NumericPrecision,$datatype.NumericScale)
	Write-Verbose "SQL: $sql"
    @{
        Query = $sql
        Database = $table.Parent.Name
        ServerInstance = $table.Parent.Parent.Name
	} |
        ? {$PSCmdlet.ShouldProcess("column $fqtn.$ColumnName","query $($table.RowCount) rows")} |
        % {Invoke-Sqlcmd @_} |
        ConvertFrom-DataRow.ps1
}
