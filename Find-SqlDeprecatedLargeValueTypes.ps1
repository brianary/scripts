<#
.SYNOPSIS
Reports text, ntext, and image datatypes found in a given database.

.OUTPUTS
Management.Automation.PSCustomObject each with an ObjectType property that
indicates what other properties are available:

Column

* ObjectType: "Column"
* ColumnName: The fully-qualified name of the column.
* DataType: Which deprecated type the column currently is
(text, ntext, or image).
* ValuesCount: The number of rows in the table, including
null values in the column.
* RowsUnder8K: The new "(max)" large data types store values
under 8K in size in-row, rather than externally, which is
faster. This is a count of how many values can be stored
in-row after conversion.
* MinDataLength: The minimum data length of the field, in
bytes, excluding nulls.
* AvgDataLength: The median average data length of the field,
in bytes, excluding nulls.
* MaxDataLength: The maximum data length of the field, in
bytes, excluding nulls.
* Sigma1: The impact of reducing the maximum data length of
the field to within one standard deviation of the mean.
* Sigma2: The impact of reducing the maximum data length of
the field to within two standard deviations of the mean.
* Sigma3: The impact of reducing the maximum data length of
the field to within three standard deviations of the mean.
* Sigma4: The impact of reducing the maximum data length of
the field to within four standard deviations of the mean.
* Sigma5: The impact of reducing the maximum data length of
the field to within five standard deviations of the mean.
* Sigma6: The impact of reducing the maximum data length of
the field to within six standard deviations of the mean.
* Sigma7: The impact of reducing the maximum data length of
the field to within seven standard deviations of the mean.
* Sigma8: The impact of reducing the maximum data length of
the field to within eight standard deviations of the mean.
* IsUserTable: True when the column's table is a user table.
False for tables in the "sys" schema, and other system tables.
* IsMsShipped: True for tables created by Microsoft, such as
dtproperties, false otherwise.
* IsMsDbTools: True for tables created by Microsoft Tools,
such as sysdiagrams, otherwise false.
* ConvertSqlScript: The SQL script that can be used to convert
the column from the deprecated large data type to the new
"(max)" type.

Parameter

* TODO

Routine

* TODO

.FUNCTIONALITY
Database

.LINK
Use-SqlcmdParams.ps1

.LINK
Invoke-Sqlcmd

.EXAMPLE
Find-SqlDeprecatedLargeValueTypes.ps1 '(localdb)\ProjectsV13' pubs


Returns text, ntext, and image columns and scripts to convert them to
the new (n)var*(max) types.
#>

#Requires -Version 3
#Requires -Module SqlServer
[CmdletBinding()][OutputType([Management.Automation.PSCustomObject])] Param(
<#
A string specifying the name of an instance of the Database Engine.
For default instances, only specify the computer name: "MyComputer".
For named instances, use the format "ComputerName\InstanceName".
#>
[Parameter(ParameterSetName='ByConnectionParameters',Position=0,Mandatory=$true)][string] $ServerInstance,
<#
A string specifying the name of a database on the server specified
by the ServerInstance parameter.
#>
[Parameter(ParameterSetName='ByConnectionParameters',Position=1,Mandatory=$true)][string] $Database,
# Specifies a connection string to connect to the server.
[Parameter(ParameterSetName='ByConnectionString',Mandatory=$true)][Alias('ConnStr','CS')][string]$ConnectionString,
# Specifies an SMO Database object to query.
[Parameter(ParameterSetName='ByDatabase',Mandatory=$true)]
[Microsoft.SqlServer.Management.Smo.Database] $SmoDatabase,
<#
The connection string name from the ConfigurationManager to use to
connect to the server.
#>
[Parameter(ParameterSetName='ByConnectionName',Mandatory=$true)][string]$ConnectionName
)
Begin { Use-SqlcmdParams.ps1 }
Process
{
    $depricols = Invoke-Sqlcmd @"
select quotename(table_catalog) table_catalog,
       quotename(table_schema) table_schema,
       quotename(table_name) table_name,
       quotename(column_name) column_name,
       data_type,
       is_nullable,
       object_id(quotename(table_catalog)+'.'+quotename(table_schema)+'.'+quotename(table_name)) table_id
  from information_schema.columns
where data_type in ('text','ntext','image');
"@
    foreach($col in $depricols)
    {
        $tableid = $col.table_id
        $table = $col.table_catalog,$col.table_schema,$col.table_name-join '.'
        $column = $col.column_name
        $nullable = if($col.is_nullable -eq 'YES'){'null'}else{'not null'}
        $maxtype = switch($col.data_type)
        {
            text  {'varchar(max)'}
            ntext {'nvarchar(max)'}
            image {'varbinary(max)'}
        }
        $updatesql = @"
alter table $table alter column $column $nullable $maxtype;
update $table set $column = $column; -- pull values <8KB in-row
"@
        $sigma = Invoke-Sqlcmd @"
select stdev(cast(datalength($column) as float)) stddev,
       avg(cast(datalength($column) as float)) avg
  from $table;
"@
        @"
select 'Column' [ObjectType],
       '$("$table.$column" -replace "'","''")' [ColumnName],
       '$($col.data_type -replace "'","''")' [DataType],
       count(*) [ValuesCount],
       sum(case when datalength($column) < 8000 then 1 else 0 end) RowsUnder8K,
       min(datalength($column)) MinDataLength,
       cast($($sigma.avg) as int) AvgDataLength,
       max(datalength($column)) MaxDataLength,
       'Length ' + cast(cast(($($sigma.stddev)+$($sigma.avg)) as int) as varchar(30)) + ' would truncate '
           + cast(sum(case when datalength($column) > ($($sigma.stddev)+$($sigma.avg)) then 1 else 0 end) as varchar(30))
           + ' values' Sigma1,
       'Length ' + cast(cast((2*$($sigma.stddev)+$($sigma.avg)) as int) as varchar(30)) + ' would truncate '
           + cast(sum(case when datalength($column) > (2*$($sigma.stddev)+$($sigma.avg)) then 1 else 0 end) as varchar(30))
           + ' values' Sigma2,
       'Length ' + cast(cast((3*$($sigma.stddev)+$($sigma.avg)) as int) as varchar(30)) + ' would truncate '
           + cast(sum(case when datalength($column) > (3*$($sigma.stddev)+$($sigma.avg)) then 1 else 0 end) as varchar(30))
           + ' values' Sigma3,
       'Length ' + cast(cast((4*$($sigma.stddev)+$($sigma.avg)) as int) as varchar(30)) + ' would truncate '
           + cast(sum(case when datalength($column) > (4*$($sigma.stddev)+$($sigma.avg)) then 1 else 0 end) as varchar(30))
           + ' values' Sigma4,
       'Length ' + cast(cast((5*$($sigma.stddev)+$($sigma.avg)) as int) as varchar(30)) + ' would truncate '
           + cast(sum(case when datalength($column) > (5*$($sigma.stddev)+$($sigma.avg)) then 1 else 0 end) as varchar(30))
           + ' values' Sigma5,
       'Length ' + cast(cast((6*$($sigma.stddev)+$($sigma.avg)) as int) as varchar(30)) + ' would truncate '
           + cast(sum(case when datalength($column) > (6*$($sigma.stddev)+$($sigma.avg)) then 1 else 0 end) as varchar(30))
           + ' values' Sigma6,
       'Length ' + cast(cast((7*$($sigma.stddev)+$($sigma.avg)) as int) as varchar(30)) + ' would truncate '
           + cast(sum(case when datalength($column) > (7*$($sigma.stddev)+$($sigma.avg)) then 1 else 0 end) as varchar(30))
           + ' values' Sigma7,
       'Length ' + cast(cast((8*$($sigma.stddev)+$($sigma.avg)) as int) as varchar(30)) + ' would truncate '
           + cast(sum(case when datalength($column) > (8*$($sigma.stddev)+$($sigma.avg)) then 1 else 0 end) as varchar(30))
           + ' values' Sigma8,
       cast(objectproperty($tableid,'IsUserTable') as bit) IsUserTable,
       cast(objectproperty($tableid,'IsMsShipped') as bit) IsMsShipped,
       cast(case when exists (select * from sys.extended_properties
           where class = 1 and major_id = $tableid and minor_id = 0
           and name = 'microsoft_database_tools_support')
           then 1 else 0 end as bit) IsMsDbTools,
       '$($updatesql -replace "'","''")' ConvertSqlScript
  from $table;
"@ |ForEach-Object {Write-Verbose $_ ; Invoke-Sqlcmd $_ |ConvertFrom-DataRow.ps1}
    }
<#
TODO: params
select SPECIFIC_NAME, PARAMETER_NAME, *
  from INFORMATION_SCHEMA.PARAMETERS
 where data_type in ('text','ntext','image');

TODO: subroutine internals? (procs, functions)
https://github.com/brianary/sqlvarmax/blob/master/SqlVarMaxScan/MaxableSubroutine.cs
#>

}
