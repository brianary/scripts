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
    Get-DbaDbTable SqlServerName -Database DbName -Table TableName |Measure-DbColumn.ps1 created

    ColumnName      : created
    SqlType         : smalldatetime
    NullValues      : 0
    IsUnique        : False
    UniqueValues    : 95
    MostCommonValue : 12/22/2015 09:51:00
    MinimumValue    : 06/17/2004 13:25:00
    MaximumValue    : 10/01/2018 06:32:00
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
        Temporal = @"
  with TopValues as (
select top 1 [{2}] value, count(*) #
  from [{0}].[{1}]
 group by [{2}]
 order by # desc
)
$SOQ
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
       sum(case when [{2}] is null then 1 else 0 end) NullValues,
       cast(case when count(*) = count(distinct [{2}]) then 1 else 0 end as bit) IsUnique,
       count(distinct [{2}]) UniqueValues,
       min(len([{2}])) MininumLength,
       max(len([{2}])) MaximumLength
$EOQ
"@
        Other = @"
$SOQ
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
        datetime         = @('Temporal','{0}')
        datetime2        = @('Temporal','{0}({3})')
        datetimeoffset   = @('Temporal','{0}({3})')
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
        smalldatetime    = @('Temporal','{0}')
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
    if(!$Column) {$Column = $Table.Columns[$ColumnName]}
    else {$ColumnName = $Column.Name}
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
