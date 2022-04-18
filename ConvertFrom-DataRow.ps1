<#
.SYNOPSIS
Converts a DataRow object to a PSObject, Hashtable, or single value.

.INPUTS
System.Data.DataRow with fields to convert into an object with properties or
into a hash with key/value pairs.

.OUTPUTS
System.Management.Automation.PSObject
or System.Object[] if -AsValues is specified
or System.Collections.Specialized.OrderedDictionary if -AsDictionary is specified

.EXAMPLE
Invoke-Sqlcmd "select top 3 ProductID, Name from Production.Product" -ServerInstance ServerName -Database AdventureWorks |ConvertFrom-DataRow.ps1 |ConvertTo-Html
#>

#Requires -Version 3
[CmdletBinding(DefaultParameterSetName='AsObject')]
[OutputType([Management.Automation.PSCustomObject],ParameterSetName='AsObject')]
[OutputType([object[]],ParameterSetName='AsValues')]
[OutputType([Collections.Specialized.OrderedDictionary],ParameterSetName='AsDictionary')] Param(
# A record containing fields/columns to convert to an object with properties.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][Data.DataRow]$DataRow,
# Indicates a the record's values should be returned as an array.
[Parameter(ParameterSetName='AsValues')][Alias('AsArray')][switch]$AsValues,
<#
Indicates an ordered dictionary of fieldnames/columnnames to values should be returned
rather than an object with properties.
#>
[Parameter(ParameterSetName='AsDictionary')][Alias('AsOrderedDictionary','AsHashtable')][switch]$AsDictionary
)
Process
{
    if($AsValues) {return $DataRow.ItemArray}
    $fields = [ordered]@{}
    if($DataRow.Table -is [Data.DataTable]) {$DataRow.Table.Columns.ColumnName |% {[void]$fields.Add($_,$DataRow[$_])}}
    if($AsDictionary) {return $fields}
    elseif($fields.Count) {return [pscustomobject]$fields}
}
