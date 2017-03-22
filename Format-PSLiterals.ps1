<#
.Synopsis
    Serializes complex content into PowerShell literals.

.Parameter Value
    An array, hash, object, or value type that can be represented as a PowerShell literal.

.Example
    ConvertFrom-Json '[{"a":1,"b":2}]' |Format-PSLiterals.ps1


    @(
        New-Object PSObject @{
            a = 1
            b = 2
        }
    )
#>

#requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,ValueFromPipeline=$true)]$Value,
[string]$Indent = '',
[string]$IndentBy = "`t"
)
Begin 
{
    $Script:OFS = "`n$Indent"
    $Local:PSDefaultParameterValues = @{
        'Format-PSLiterals.ps1:Indent'   = "$Indent$IndentBy"
        'Format-PSLiterals.ps1:IndentBy' = $IndentBy
    }
}
Process
{
    if($Value -eq $null) {}
    elseif($Value -is [int])
    { "$Value" }
    elseif($Value -is [bool])
    { "`$$Value" }
    elseif([byte],[decimal],[double],[float],[int16],[long],[sbyte],[uint16],[uint32],[uint64] -contains $Value.GetType())
    { "[$($Value.GetType().Name)]$Value" }
    elseif([guid],[timespan],[char] -contains $Value.GetType())
    { "[$($Value.GetType().Name)]'$Value'" }
    elseif($Value -is [datetimeoffset])
    { "[datetimeoffset]'$($Value.ToString('yyyy-MM-dd\THH:mm:ss.fffffzzzz'))'" }
    elseif($Value -is [datetime])
    { "[datetime]'$(Get-Date -Date $Value -f yyyy-MM-dd\THH:mm:ss)'" }
    elseif($Value -is [string])
    { "'$($Value -replace "'","''")'" }
    elseif($Value -is [array])
    {
        "$Indent@("
        $Value |% {Format-PSLiterals.ps1 $_}
        "$Indent)"
    }
    elseif($Value -is [PSObject])
    {
        "${Indent}New-Object PSObject @{"
        $Value.PSObject.Properties |
            ? {$_.Name -match '^\w+$'} |
            % {"$Indent$IndentBy$($_.Name) = $(Format-PSLiterals.ps1 $_.Value)"}
        "$Indent}"
    }
    elseif($Value -is [Hashtable] -or $Value -is [Collections.Specialized.OrderedDictionary])
    {
        "$Indent@{"
        $Value.Keys |? {$_ -match '^\w+$'} |% {"$Indent$IndentBy$_ = $(Format-PSLiterals.ps1 $Value.$_)"}
        "$Indent}"
    }
    elseif($Value -is [xml])
    { "'$($Value.OuterXml -replace "'","''")'" }
    else
    {
        "$Indent@{"
        Get-Member -InputObject $Value.PSObject.Properties -MemberType Properties |
            ? {$_.Name -match '^\w+$'} |
            % {"$Indent$IndentBy$($_.Name) = $(Format-PSLiterals.ps1 $Value.$($_.Value))"}
        "$Indent}"
    }
}