<#
.SYNOPSIS
Converts an object to an ordered dictionary of properties and values.

.PARAMETER InputObject
An object to convert to a dictionary.

.INPUTS
Any .NET object to convert into a properties hash.

.OUTPUTS
System.Collections.Specialized.OrderedDictionary of the object's property names and values.

.LINK
Get-Member

.EXAMPLE
ls *.txt |ConvertTo-OrderedDictionary.ps1
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Collections.Specialized.OrderedDictionary])] Param(
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
