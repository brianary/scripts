<#
.SYNOPSIS
Provides frequency details about the properties across objects in the pipeline.

.INPUTS
System.Object values to be analyzed in aggregate.

.OUTPUTS
System.Management.Automation.PSCustomObject that describes the properties of the objects:
* PropertyName
* Type
* Unique
* Nulls
* Values
* Minimum
* Maximum

.FUNCTIONALITY
Data

.LINK
Write-Info.ps1

.LINK
Stop-ThrowError.ps1

.EXAMPLE
Get-PSDrive |Measure-Properties.ps1 |Format-Table -AutoSize

Type: System.Management.Automation.PSDriveInfo
Count: 13

PropertyName           Type           Unique Nulls Values         Minimum                   Maximum
------------           ----           ------ ----- ------         -------                   -------
Used                   System.Object   False    12      1 219129761792.00           219129761792.00
Free                   System.Object   False    12      1 803764846592.00           803764846592.00
CurrentLocation        System.String   False    11      2                               Users\brian
Name                   System.String    True     0     13               A                     WSMan
Root                   System.String   False     4      9               \               SQLSERVER:\
Description            System.String   False     1     12                 X509 Certificate Provider
VolumeSeparatedByColon System.Boolean  False    12      1            1.00                      1.00
#>

#Requires -Version 7
[CmdletBinding()] Param(
[Parameter(ValueFromPipeline=$true)] $InputObject
)
Begin
{
    $typename = New-Object Collections.Generic.HashSet[string]
    [long] $count = 0
    $type = [ordered]@{}
    $nullvalue = [ordered]@{}
    $value = [ordered]@{}
}
Process
{
    [void]$typename.Add($null -eq $InputObject ? '(null)' : $InputObject.GetType().FullName)
    $count++
    foreach($property in $InputObject.PSObject.Properties)
    {
        $propname,$propvalue,$proptype = $property.Name,$property.Value,$property.TypeNameOfValue
        if($propvalue -isnot [icomparable]) {continue}
        if(!$type.Contains($propname)) {$type[$propname] = $proptype}
        if(!$nullvalue.Contains($propname)) {$nullvalue[$propname] = 0}
        if($null -eq $propvalue)
        {
            $nullvalue[$propname]++
        }
        elseif($value.Contains($propname))
        {
            if($proptype -ne $type[$propname])
            {
                Stop-ThrowError.ps1 "Property '$propname' has conflicting types: '$($type[$propname])' vs '$proptype'" -Argument InputObject
            }
            $value[$propname] += $propvalue
        }
        else
        {
            $value[$propname] = @($propvalue)
        }
    }
}
End
{
    Write-Info.ps1 'Type: ' -fg Green -NoNewLine
    Write-Info.ps1 ($typename.GetEnumerator() -join ', ') -fg Gray
    Write-Info.ps1 'Count: ' -fg Green -NoNewLine
    Write-Info.ps1 $count -fg Gray
    foreach($propname in $value.Keys)
    {
        $uniquevalues = @($value[$propname] |Select-Object -Unique).Count
        #TODO: detect numeric types for stats
        $stats = $value[$propname] |Measure-Object -Minimum -Maximum
        #TODO: detect stringc type for length stats
        #TODO: detect datetime types for expanded stats?
        [pscustomobject]@{
            PropertyName = $propname
            Type         = $type[$propname]
            Unique       = $count -eq $uniquevalues
            Nulls        = $count - $uniquevalues
            Values       = $uniquevalues
            Minimum      = $stats.Minimum
            Maximum      = $stats.Maximum
        }
    }
}
