<#
.Synopsis
    Converts a DataRow object to a PSObject.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][Data.DataRow]$DataRow
)
Process
{
    $fields = [ordered]@{}
    $DataRow.Table.Columns |% ColumnName |% {[void]$fields.Add($_,$DataRow[$_])}
    New-Object psobject -Property $fields
}