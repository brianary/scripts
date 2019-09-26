<#
.Synopsis
    Serializes complex content into PowerShell literals.

.Parameter Value
    An array, hash, object, or value type that can be represented as a PowerShell literal.

.Parameter Indent
    The starting indent value. You can probably ignore this.

.Parameter IndentBy
    The string to use for incremental indentation.

.Parameter Newline
    The line ending sequence to use.

.Parameter SkipInitialIndent
    Indicates the first line has already been indented. You can probably ignore this.

.Parameter GenerateKey
    Generates a key to use for encrypting credential literals.
    If this is omitted, credentials will be encrypted using DPAPI, which will only be
    decryptable on the same Windows machine where they were encrypted.

.Parameter Key
    The key to use for encrypting credentials.

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
[string]$Newline = "`r`n",
[switch]$SkipInitialIndent,
[Alias('PortableKey')][switch]$GenerateKey,
[byte[]]$Key
)
Begin
{
    $Script:OFS = "$Newline$Indent"
    $Local:PSDefaultParameterValues = @{
        'Format-PSLiterals.ps1:Indent'   = "$Indent$IndentBy"
        'Format-PSLiterals.ps1:IndentBy' = $IndentBy
    }
    $itab = if($SkipInitialIndent){''}else{$Indent}
    $tab = $Indent
    $tabtab = "$Indent$IndentBy"
    if($GenerateKey)
    {
        [byte[]]$Key = 0..31 |% {Get-Random -Maximum 255}
        "[byte[]]`$key = $($Key -join ',')"
    }
    if($Key)
    {
        $Local:PSDefaultParameterValues['Format-PSLiterals.ps1:Key'] = $Key
        $keyopt = ' -Key $key'
        $dpapiwarn = ''
        $Script:PSDefaultParameterValues['ConvertFrom-SecureString:Key'] = $Key
    }
    else
    {
        $keyopt = ''
        $dpapiwarn = " # using DPAPI, only valid for $env:UserName on $env:ComputerName as of $(Get-Date)"
    }

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
        if($string -match '\n|\r') {"@$q$Newline$string$Newline$q@"}
        else {"$itab$q$string$q"}
    }

    function Format-WrapString([Parameter(ValueFromPipeline=$true)][string]$string,[int]$width = 80)
    {Process{
        for($i = 0; ($i+$width) -lt $string.Length; $i += $width) {$string.Substring($i,$width)}
        if($string.Length % $width) {$string.Substring($string.Length - ($string.Length % $width))}
    }}

    $typealias = @{}
    (Get-TypeAccelerators.ps1).GetEnumerator() |% {$typealias[$_.Value.FullName] = $_.Key}
    function Format-ParameterType([Parameter(ValueFromPipelineByPropertyName=$true)][type]$ParameterType)
    {Process{
        $value = $ParameterType.FullName
        if($typealias.ContainsKey($value)) {$value = $typealias[$value]}
        "[$value]"
    }}

    function Format-ParameterAttribute([Parameter(ValueFromPipeline=$true)][attribute]$Attribute)
    {Process{
        Import-Variables.ps1 $Attribute
        $name = $Attribute.GetType().Name -replace 'Attribute\z',''
        switch($name)
        {
            Parameter
            {
                $props = @()
                if($ParameterSetName -ne '__AllParameterSets') {$props += "ParameterSetName=$ParameterSetName"}
                if($Position -ne [int]::MinValue) {$props += "Position=$Position"}
                'Mandatory','ValueFromPipeline','ValueFromPipelineByPropertyName','ValueFromRemainingArguments' |
                    foreach {try{Get-Variable $_ -ErrorAction Stop}catch{}} |
                    where {$_.Value} |
                    foreach {$props += "$($_.Name)=`$$($_.Value.ToString().ToLower())"}
                if($props){"[$name($($props -join ','))]"} else {''}
            }
            Alias {"[Alias($(($AliasNames |Format-PSLiterals.ps1 -SkipInitialIndent) -join ','))]"}
            ValidateCount {"[$name($MinLength,$MaxLength)]"}
            ValidateDrive {"[$name($(($ValidRootDrives |Format-PSLiterals.ps1 -SkipInitialIndent) -join ','))]"}
            ValidateLength {"[$name($MinLength,$MaxLength)]"}
            ValidatePattern {"[$name('$($RegexPattern -replace "'","''")')]"}
            ValidateRange {"[$name($MinRange,$MaxRange)]"}
            ValidateScript {"[$name({$ScriptBlock})]"}
            ValidateSet {"[$name($(($ValidValues |Format-PSLiterals.ps1 -SkipInitialIndent) -join ','))]"}
            default {"[$name()]"}
        }
    }}
}
Process
{
    if($null -eq $Value)
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
    elseif($Value -is [enum])
    { "$itab([$($Value.GetType().FullName)]::$Value)" }
    elseif($Value -is [string])
    { Format-PSString $Value }
    elseif($Value -is [array])
    {
        "${itab}@("
        $Value |% {Format-PSLiterals.ps1 $_}
        "${tab})"
    }
    elseif($Value -is [securestring])
    {
        $password = (ConvertFrom-SecureString $Value |Format-WrapString) -join "' +$Newline${tabtab}'"
        "(ConvertTo-SecureString ($Newline${tabtab}'$password')$keyopt)$dpapiwarn"
    }
    elseif($Value -is [pscredential])
    {
        $username = "'$($Value.UserName -replace "'","''")'"
        $password = (ConvertFrom-SecureString $Value.Password |Format-WrapString) -join "' +$Newline${tabtab}'"
        $password = "(ConvertTo-SecureString ($Newline${tabtab}'$password')$keyopt)"
        "${itab}New-Object pscredential $username,$password$dpapiwarn"
    }
    elseif($Value -is [Management.Automation.RuntimeDefinedParameterDictionary])
    {
        "${itab}Param("
        ($Value.GetEnumerator() |% {"$tabtab$(Format-PSLiterals.ps1 $_.Value)"}) -join ','
        "${itab})"
    }
    elseif($Value -is [Management.Automation.RuntimeDefinedParameter])
    {
        "$($Value.Attributes |Format-ParameterAttribute)"
        "$itab$($Value |Format-ParameterType) `$$($Value.Name)"
    }
    elseif($Value -is [ScriptBlock])
    { "{$Value}" }
    elseif($Value -is [Collections.Specialized.OrderedDictionary])
    {
        "${itab}([ordered]@{"
        $Value.Keys |? {$_ -match '^\w+$'} |% {"$tabtab$_ = $(Format-PSLiterals.ps1 $Value.$_ -SkipInitialIndent)"}
        "${tab}})"
    }
    elseif($Value -is [Hashtable])
    {
        "${itab}@{"
        $Value.Keys |? {$_ -match '^\w+$'} |% {"$tabtab$_ = $(Format-PSLiterals.ps1 $Value.$_ -SkipInitialIndent)"}
        "${tab}}"
    }
    elseif($Value -is [xml])
    { "[xml]$(Format-PSString $Value.OuterXml)" }
    elseif($Value -is [PSObject])
    {
        "${itab}[PSCustomObject]@{"
        $Value |
            Get-Member -MemberType Properties |
            ? Name -NotLike '\W' |
            % Name |
            % {"$Indent$IndentBy$_ = $(Format-PSLiterals.ps1 $Value.$_ -SkipInitialIndent)"}
        "${tab}}"
    }
    else
    {
        "${itab}@{"
        $Value |
            Get-Member -MemberType Properties |
            ? Name -NotLike '\W' |
            % Name |
            % {"$Indent$IndentBy$_ = $(Format-PSLiterals.ps1 $Value.$_ -SkipInitialIndent)"}
        "${tab}}"
    }
}
