<#
.Synopsis
    Serializes complex content into PowerShell literals.

.Parameter Value
    An array, hash, object, or value type that can be represented as a PowerShell literal.

.Inputs
    System.Object (any object) to serialize.

.Outputs
    System.String[] containing lines of the object serialized to PowerShell literal statements.

.Example
    ConvertFrom-Json '[{"a":1,"b":2,"c":{"d":"\/Date(1490216371478)\/","e":null}}]' |Format-PSLiterals.ps1

    @(
            [PSCustomObject]@{
                    a = 1
                    b = 2
                    c = [PSCustomObject]@{
                                    d = [datetime]'2017-03-22T20:59:31'
                                    e = $null
                            }
            }
    )
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string[]])] Param(
[Parameter(Position=0,ValueFromPipeline=$true)]$Value,
[string]$Indent = '',
[string]$IndentBy = "`t",
[switch]$SkipInitialIndent
)
Begin 
{
    $Script:OFS = "`n$Indent"
    $Local:PSDefaultParameterValues = @{
        'Format-PSLiterals.ps1:Indent'   = "$Indent$IndentBy"
        'Format-PSLiterals.ps1:IndentBy' = $IndentBy
    }
    $itab = if($SkipInitialIndent){''}else{$Indent}
    $tab = $Indent
    $tabtab = "$Indent$IndentBy"

    function Format-PSString([string]$string)
    {
        $q,$string =
            if($string -match '[\0\a\b\f\t\v]')
            {
                '"'
                $string -replace '$','`$' -replace '`','``' -replace '"','`"' -replace "`0",'`0' -replace "`a",'`a' -replace "`b",'`b' -replace "`f",'`f' -replace "`t",'`t' -replace "`v",'`v'
            }
            else
            {
                "'"
                $string -replace "'","''"
            }
        if($string -match '\n|\r') {"@$q`n$string`n$q@"}
        else {"$itab$q$string$q"}
    }
}
Process
{
    if($Value -eq $null)
    { "$itab`$null" }
    elseif($Value -is [int])
    { "$itab$Value" }
    elseif($Value -is [bool])
    { "$itab`$$Value" }
    elseif([byte],[decimal],[double],[float],[int16],[long],[sbyte],[uint16],[uint32],[uint64] -contains $Value.GetType())
    { "$itab[$($Value.GetType().Name)]$Value" }
    elseif([guid],[timespan],[char] -contains $Value.GetType())
    { "$itab[$($Value.GetType().Name)]'$Value'" }
    elseif($Value -is [datetimeoffset])
    { "$itab[datetimeoffset]'$($Value.ToString('yyyy-MM-dd\THH:mm:ss.fffffzzzz'))'" }
    elseif($Value -is [datetime])
    { "$itab[datetime]'$(Get-Date -Date $Value -f yyyy-MM-dd\THH:mm:ss)'" }
    elseif($Value -is [string])
    { Format-PSString $Value }
    elseif($Value -is [array])
    {
        "${itab}@("
        $Value |% {Format-PSLiterals.ps1 $_}
        "${tab})"
    }
    elseif($Value -is [ScriptBlock])
    { "{$Value}" }
    elseif($Value -is [Collections.Specialized.OrderedDictionary])
    {
        "${itab}([ordered]@{"
        $Value.Keys |? {$_ -match '^\w+$'} |% {"$Indent$IndentBy$_ = $(Format-PSLiterals.ps1 $Value.$_ -SkipInitialIndent)"}
        "${tab}})"
    }
    elseif($Value -is [Hashtable])
    {
        "${itab}@{"
        $Value.Keys |? {$_ -match '^\w+$'} |% {"$Indent$IndentBy$_ = $(Format-PSLiterals.ps1 $Value.$_ -SkipInitialIndent)"}
        "${tab}}"
    }
    elseif($Value -is [xml])
    { "[xml]$(Format-PSString $Value.OuterXml)" }
    elseif($Value -is [PSObject])
    {
        "${itab}[PSCustomObject]@{"
        $Value.PSObject.Properties |
            ? {$_.Name -match '^\w+$'} |
            % {"$Indent$IndentBy$($_.Name) = $(Format-PSLiterals.ps1 $_.Value -SkipInitialIndent)"}
        "${tab}}"
    }
    else
    {
        "${itab}@{"
        Get-Member -InputObject $Value.PSObject.Properties -MemberType Properties |
            ? {$_.Name -match '^\w+$'} |
            % {"$Indent$IndentBy$($_.Name) = $(Format-PSLiterals.ps1 $Value.$($_.Value) -SkipInitialIndent)"}
        "${tab}}"
    }
}
