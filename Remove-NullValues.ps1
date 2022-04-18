<#
.SYNOPSIS
Removes dictionary entries with null vaules.

.INPUTS
System.Collections.IDictionary to remove nulls from.

.OUTPUTS
System.Collections.IDictionary with null-valued entries removed.

.EXAMPLE
@{ a = 1; b = $null; c = 3 } |Remove-NullValues.ps1

Name                           Value
----                           -----
c                              3
a                              1
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Collections.IDictionary])] Param(
# A dictionary to remove the nulls from.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][Collections.IDictionary] $InputObject
)
Process
{
    $nullvaluekeys = $InputObject.Keys |where {$InputObject[$_] -eq $null}
    $nullvaluekeys |foreach {$InputObject.Remove($_)}
    return $InputObject
}
