<#
.Synopsis
    Converts a DataRow object to a PSObject.

.Parameter DataRow
    A record containing fields/columns to convert to an object with properties.

.Parameter AsDictionary
    Indicates an ordered dictionary of fieldnames/columnnames to values should be returned
    rather than an object with properties.

.Inputs
    System.Data.DataRow with fields to convert into an object with properties or
    into a hash with key/value pairs.

.Outputs
    System.Management.Automation.PSObject
    or System.Collections.Specialized.OrderedDictionary if -AsDictionary is specified

.Example
    Invoke-Sqlcmd "select top 3 ProductID, Name from Production.Product" -ServerInstance ServerName -Database AdventureWorks |ConvertFrom-DataRow.ps1 |ConvertTo-Html
#>

#Requires -Version 3
[CmdletBinding(DefaultParameterSetName='AsObject')][OutputType([psobject],ParameterSetName='AsObject')]
[OutputType([Collections.Specialized.OrderedDictionary],ParameterSetName='AsDictionary')] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][Data.DataRow]$DataRow,
[Parameter(ParameterSetName='AsDictionary')][Alias('AsOrderedDictionary','AsHashtable')][switch]$AsDictionary
)
Process
{
    $fields = [ordered]@{}
    if($DataRow.Table -is [Data.DataTable]) {$DataRow.Table.Columns.ColumnName |% {[void]$fields.Add($_,$DataRow[$_])}}
    if($AsDictionary) {$fields}
    elseif($fields.Count) {[pscustomobject]$fields}
}
