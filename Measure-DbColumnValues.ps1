<#
.SYNOPSIS
Provides sorted counts of SQL Server column values.

.INPUTS
Microsoft.SqlServer.Management.Smo.Column to calculate statistics for,
or Microsoft.SqlServer.Management.Smo.Table to select a column from by name.

.OUTPUTS
System.Management.Automation.PSCustomObject that describes each counted value.

.FUNCTIONALITY
Database

.LINK
https://www.powershellgallery.com/packages/SqlServer/

.LINK
https://dbatools.io/
#>

#Requires -Version 3
#Requires -Module SqlServer
[CmdletBinding(ConfirmImpact='Medium')][OutputType([Management.Automation.PSCustomObject])] Param(
# An SMO column object associated to the database column to examine.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ParameterSetName='Column')]
[Microsoft.SqlServer.Management.Smo.Column] $Column,
# The name of the column to examine in the table associated with the SMO Table object.
[Parameter(Position=0,Mandatory=$true,ParameterSetName='ColumnName')][string] $ColumnName,
# An SMO table object associated to the database to examine.
[Parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true,ParameterSetName='ColumnName')]
[Microsoft.SqlServer.Management.Smo.Table] $Table,
<#
Conditions to be provided as a SQL WHERE clause to filter the column values to examine.
Useful for databases that implement "soft deletes" as specific field values.
#>
[string] $Condition,
# Excludes values with fewer than this number of occurrences.
[int] $MinimumCount
)
Begin
{
	$query = @"
select [{2}] [Value], count(*) [Count]
  from [{0}].[{1}]
$(if($Condition){" where $Condition"})
 group by [{2}]
$(if($MinimumCount){"having count(*) > $MinimumCount"})
 order by [Count] desc;
"@
}
Process
{
	if($Column) {$ColumnName = $Column.Name}
	else
	{
		$Column = $Table.Columns[$ColumnName]
		if(!$Column) {Stop-ThrowError.ps1 "Column '$ColumnName' not found in table '$($Table.Name)'" -Argument ColumnName}
	}
	$table = $Column.Parent
	$fqtn = "$($table.Parent.Parent.Name).$($table.Parent.Name).$($table.Name)"
	$sql = $query -f $table.Schema,$table.Name,$ColumnName
	Write-Verbose "SQL: $sql"
	@{
		Query = $sql
		Database = $table.Parent.Name
		ServerInstance = $table.Parent.Parent.Name
	} |
		Where-Object {$PSCmdlet.ShouldProcess("column $fqtn.$ColumnName","query $($table.RowCount) rows")} |
		ForEach-Object {Invoke-Sqlcmd @_} |
		ConvertFrom-DataRow.ps1
}
