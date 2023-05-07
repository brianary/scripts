<#
.SYNOPSIS
Provides frequency details about SQL Server table data.

.INPUTS
Microsoft.SqlServer.Management.Smo.Table to analyze.

.OUTPUTS
System.Management.Automation.PSCustomObject that describes each table column.

.FUNCTIONALITY
Database

.LINK
https://www.powershellgallery.com/packages/SqlServer/

.LINK
https://dbatools.io/

.EXAMPLE
Get-DbaDbTable -sqli '(localdb)\ProjectsV13' -dat AdventureWorks2016 -tab Production.Product |Measure-DbTable.ps1

#TableName            : [Production].[Product]
#RowCount             : 504
ProductID             : unique, 0 nulls, 504 values: 1 .. 999
Name                  : unique, 0 nulls, 504 values: Adjustable Race .. Women's Tights, S
ProductNumber         : unique, 0 nulls, 504 values: AR-5381 .. WB-H098
MakeFlag              : bit: 0 nulls, 239 ones, 265 zeros
FinishedGoodsFlag     : bit: 0 nulls, 295 ones, 209 zeros
Color                 : 248 nulls, 9 values: Black .. Yellow
SafetyStockLevel      : 0 nulls, 6 values: 4 .. 1000
ReorderPoint          : 0 nulls, 6 values: 3 .. 750
StandardCost          : 0 nulls, 114 values: 0.00 .. 2171.29
ListPrice             : 0 nulls, 103 values: 0.00 .. 3578.27
Size                  : 293 nulls, 18 values: 38 .. XL
SizeUnitMeasureCode   : CM
WeightUnitMeasureCode : 299 nulls, 2 values: G   .. LB
Weight                : 299 nulls, 127 values: 2.12 .. 1050.00
DaysToManufacture     : 0 nulls, 4 values: 0 .. 4
ProductLine           : 226 nulls, 4 values: M  .. T
Class                 : 257 nulls, 3 values: H  .. M
Style                 : 293 nulls, 3 values: M  .. W
ProductSubcategoryID  : 209 nulls, 37 values: 1 .. 37
ProductModelID        : 209 nulls, 119 values: 1 .. 128
SellStartDate         : 0 nulls, 4 values: Apr 30 2008 12:00AM .. May 30 2013 12:00AM
SellEndDate           : 406 nulls, 2 values: May 29 2012 12:00AM .. May 29 2013 12:00AM
DiscontinuedDate      : null
rowguid               : unique, 0 nulls, 504 values: 7A927632-99A4-4F24-ADCE-0062D2D113D9 .. B9EDE243-A6F4-4629-B1D4-FFE1AEDC6DE7
ModifiedDate          : 0 nulls, 2 values: Feb  8 2014 10:01AM .. Feb  8 2014 10:03AM
#>

#Requires -Version 3
#Requires -Module SqlServer
[CmdletBinding(ConfirmImpact='Medium')][OutputType([Management.Automation.PSCustomObject])] Param(
# An SMO table object associated to the database to examine.
[Parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true)]
[Microsoft.SqlServer.Management.Smo.Table] $Table,
<#
Conditions to be provided as a SQL WHERE clause to filter the record values to examine.
Useful for databases that implement "soft deletes" as specific field values.
#>
[string] $Condition
)
Begin
{
	function Format-ColumnRange([string]$colname)
	{@"
case count([$colname])
		when count(*) then 'not null, ' +
			cast(count(distinct [$colname]) as varchar(max)) + ' values: ' +
			cast(min([$colname]) as varchar(max)) + ' .. ' + cast(max([$colname]) as varchar(max))
		when 0 then 'null'
		else cast(count(*) - count([$colname]) as varchar(max)) + ' nulls, ' +
			cast(count(distinct [$colname]) as varchar(max)) + ' values: ' +
			cast(min([$colname]) as varchar(max)) + ' .. ' + cast(max([$colname]) as varchar(max))
		end
"@}
	filter Format-ColumnCount
	{
		$colname = $_.Name
		switch($_.DataType.Name)
		{
			{$_ -in 'bit','Flag'}
			{@"
,
			'bit: ' +
			cast(count(*) - count([$colname]) as varchar(max)) + ' nulls, ' +
			cast(sum(cast([$colname] as int)) as varchar(max)) + ' ones, ' +
			cast(count([$colname]) - sum(cast([$colname] as int)) as varchar(max)) + ' zeros'
			[$colname]
"@}
			{$_ -in 'text','ntext','image'}
			{@"
,
			'text/image: ' +
			case sum(case when [$colname] is null then 1 else 0 end)
			when 0 then 'not null'
			when count(*) then 'null'
			else cast(count(*) - sum(case when [$colname] is null then 1 else 0 end) as varchar(max)) + ' nulls, ' +
			cast(sum(case when [$colname] is null then 1 else 0 end) as varchar(max)) + ' values'
			end
			[$colname]
"@}
			default
			{@"
,
			case count(distinct [$colname])
			when 0 then 'null'
			when 1 then cast(min([$colname]) as varchar(max))
			when count(*) then 'unique, ' + $(Format-ColumnRange $colname)
			when count([$colname]) then 'nullable unique (no duplicates), ' + $(Format-ColumnRange $colname)
			else $(Format-ColumnRange $colname)
			end
			[$colname]
"@}
		}
	}
	$SOQ = "select '[{0}].[{1}]' #TableName, count(*) #RowCount"
	$EOQ = if(!$Condition) {' from [{0}].[{1}];'} else {" from [{0}].[{1}] where $Condition ;"}
}
Process
{
	$sql = "$SOQ $($Table.Columns |Format-ColumnCount) $EOQ" -f $Table.Schema,$Table.Name
	Write-Verbose "SQL: $sql"
	@{
		Query = $sql
		Database = $Table.Parent.Name
		ServerInstance = $Table.Parent.Parent.Name
	} |
		Where-Object {$PSCmdlet.ShouldProcess("column $Table","query $($Table.RowCount) rows")} |
		ForEach-Object {Invoke-Sqlcmd @_} |
		ConvertFrom-DataRow.ps1
}
