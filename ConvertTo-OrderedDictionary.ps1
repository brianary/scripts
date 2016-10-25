<#
.Synopsis
    Converts an object to an ordered dictionary of properties and values.

.Parameter InputObject
    An object to convert to a dictionary.

.Outputs
    System.Collections.Specialized.OrderedDictionary

.Link
    Get-Member

.Example
    ls *.txt |ConvertTo-Hashtable.ps1
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]$InputObject
)
Process
{
    $properties = [ordered]@{}
    Get-Member -InputObject $InputObject -MemberType Properties |
        % Name |
        % {[void]$properties.Add($_,$InputObject.$_)}
    $properties
}