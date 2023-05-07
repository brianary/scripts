<#
.SYNOPSIS
Converts an object to an ordered dictionary of properties and values.

.INPUTS
Any .NET object to convert into a properties hash.

.OUTPUTS
System.Collections.Specialized.OrderedDictionary of the object's property names and values.

.FUNCTIONALITY
Dictionary

.LINK
Get-Member

.EXAMPLE
ls *.txt |ConvertTo-OrderedDictionary.ps1
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Collections.Specialized.OrderedDictionary])] Param(
# An object to convert to a dictionary.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]$InputObject
)
Process
{
    $properties = [ordered]@{}
    Get-Member -InputObject $InputObject -MemberType Properties |
        Select-Object -ExpandProperty Name |
        ForEach-Object {[void]$properties.Add($_,$InputObject.$_)}
    $properties
}

