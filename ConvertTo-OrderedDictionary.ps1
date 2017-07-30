<#
.Synopsis
    Converts an object to an ordered dictionary of properties and values.

.Parameter InputObject
    An object to convert to a dictionary.

.Inputs
    Any .NET object to convert into a properties hash.

.Outputs
    System.Collections.Specialized.OrderedDictionary of the object's property names and values.

.Link
    Get-Member

.Example
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
