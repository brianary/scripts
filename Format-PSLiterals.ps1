<#
.Synopsis
    Serializes complex content into PowerShell literals.

.Parameter Value
    An array, hash, object, or value type that can be represented as a PowerShell literal.

.Example
    ConvertFrom-Json '[{"a":1,"b":2,"c":{"d":"\/Date(1490216371478)\/","e":null}}]' |Format-PSLiterals.ps1

    @(
	    New-Object PSObject -Property ([ordered]@{
		    a = 1
		    b = 2
		    c = New-Object PSObject -Property ([ordered]@{
				    d = [datetime]'2017-03-22T20:59:31'
				    e = $null
			    })
	    })
    )
#>

#requires -Version 3
[CmdletBinding()] Param(
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
                $string -replace '`','``' -replace '"','`"' -replace "`0",'`0' -replace "`a",'`a' -replace "`b",'`b' -replace "`f",'`f' -replace "`t",'`t' -replace "`v",'`v'
            }
            else
            {
                "'"
                $string -replace "'","''"
            }
        if($string -match '\n|\r') {"@$q`n$string`n$q@"}
        else {"$q$string$q"}
    }
}
Process
{
    if($Value -eq $null)
    { '$null' }
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
    { Format-PSString $Value }
    elseif($Value -is [array])
    {
        "${itab}@("
        $Value |% {Format-PSLiterals.ps1 $_}
        "${tab})"
    }
    elseif($Value -is [PSObject])
    {
        "${itab}New-Object PSObject -Property ([ordered]@{"
        $Value.PSObject.Properties |
            ? {$_.Name -match '^\w+$'} |
            % {"$Indent$IndentBy$($_.Name) = $(Format-PSLiterals.ps1 $_.Value -SkipInitialIndent)"}
        "${tab}})"
    }
    elseif($Value -is [Hashtable])
    {
        "${itab}@{"
        $Value.Keys |? {$_ -match '^\w+$'} |% {"$Indent$IndentBy$_ = $(Format-PSLiterals.ps1 $Value.$_ -SkipInitialIndent)"}
        "${tab}}"
    }
    elseif($Value -is [Collections.Specialized.OrderedDictionary])
    {
        "${itab}([ordered]@{"
        $Value.Keys |? {$_ -match '^\w+$'} |% {"$Indent$IndentBy$_ = $(Format-PSLiterals.ps1 $Value.$_ -SkipInitialIndent)"}
        "${tab}})"
    }
    elseif($Value -is [xml])
    { "[xml]$(Format-PSString $Value.OuterXml)" }
    else
    {
        "${itab}@{"
        Get-Member -InputObject $Value.PSObject.Properties -MemberType Properties |
            ? {$_.Name -match '^\w+$'} |
            % {"$Indent$IndentBy$($_.Name) = $(Format-PSLiterals.ps1 $Value.$($_.Value) -SkipInitialIndent)"}
        "${tab}}"
    }
}