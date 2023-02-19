<#
.SYNOPSIS
Serializes complex content into PowerShell literals.

.INPUTS
System.Object (any object) to serialize.

.OUTPUTS
System.String containing the object serialized to PowerShell literal statements.

.FUNCTIONALITY
Data formats

.EXAMPLE
4096LMB |ConvertTo-PowerShell.ps1

4LGB

.EXAMPLE
ConvertFrom-Json '[{"a":1,"b":2,"c":{"d":"\/Date(1490216371478)\/","e":null}}]' |ConvertTo-PowerShell.ps1

[pscustomobject]@{
        a = 1L
        b = 2L
        c = [pscustomobject]@{
                d = [datetime]'2017-03-22T20:59:31'
                e = $null
        }
}
#>

#Requires -Version 3
[CmdletBinding(DefaultParameterSetName='GenerateKey')][OutputType([string])] Param(
# An array, hash, object, or value type that can be represented as a PowerShell literal.
[Parameter(Position=0,ValueFromPipeline=$true)] $Value,
# The starting indent value. You can probably ignore this.
[string] $Indent = '',
# The string to use for incremental indentation.
[string] $IndentBy = "`t",
# The line ending sequence to use.
[string] $Newline = [environment]::NewLine,
# Indicates the first line has already been indented. You can probably ignore this.
[switch] $SkipInitialIndent,
# The maximum width of string literals.
[ValidateRange(1,0xFFFF)][uint16] $Width = 80,
<#
Generates a key to use for encrypting credential and secure string literals.
If this is omitted, credentials will be encrypted using DPAPI, which will only be
decryptable on the same Windows machine where they were encrypted.
#>
[Parameter(ParameterSetName='GenerateKey')][Alias('PortableKey')][switch] $GenerateKey,
<#
The key to use for encrypting credentials and secure strings, as a secure string to be
encoded into UTF-8 bytes.
#>
[Parameter(ParameterSetName='SecureKey',Mandatory=$true)][securestring] $SecureKey,
<#
A credential containing a password (the username is ignored) to be used for encrypting
credentials and secure strings, after encoding to UTF-8 bytes.
#>
[Parameter(ParameterSetName='Credential',Mandatory=$true)][pscredential] $Credential,
# The key to use for encrypting credentials and secure strings, as a byte array.
[Parameter(ParameterSetName='KeyBytes',Mandatory=$true)][byte[]] $KeyBytes
)
Begin
{
	$Script:OFS = "$Newline$Indent"
	$Local:PSDefaultParameterValues = @{
		'ConvertTo-PowerShell.ps1:Indent'   = "$Indent$IndentBy"
		'ConvertTo-PowerShell.ps1:IndentBy' = $IndentBy
		'ConvertTo-PowerShell.ps1:Width'    = $Width
	}
	$itab = if($SkipInitialIndent){''}else{$Indent}
	$tab = $Indent
	$tabtab = "$Indent$IndentBy"
	$units = @{ 1LKB = 'KB'; 1LMB = 'MB'; 1LGB = 'GB'; 1LTB = 'TB'; 1LPB = 'PB' }
	if($GenerateKey)
	{
		[byte[]] $KeyBytes = Get-RandomBytes.ps1 32
		"[byte[]]`$key = $($KeyBytes -join ',')"
	}
	elseif($SecureKey)
	{
		$Credential = New-Object pscredential 'SecureKey',$SecureKey
	}
	if($Credential)
	{
		[byte[]] $salt = Get-RandomBytes.ps1 8
		$hash = New-Object Security.Cryptography.Rfc2898DeriveBytes `
			([Text.Encoding]::UTF8.GetBytes(($Credential.Password |ConvertFrom-SecureString -AsPlainText))),$salt,
			(Get-Random 9999 -Minimum 1000)
		$iterations = $hash.IterationCount
		[byte[]] $salt = $hash.Salt
		[byte[]] $KeyBytes = $hash.GetBytes(32)
		$hash.Dispose(); $hash = $null
		$creduser = $Credential.UserName -replace "'","''"
		"`$hash = New-Object Security.Cryptography.Rfc2898DeriveBytes ``"
		"	([Text.Encoding]::UTF8.GetBytes(((Get-Credential '$creduser').Password |ConvertFrom-SecureString -AsPlainText)),"
		"	($($salt -join ',')),$iterations"
		"[byte[]]`$key = `$hash.GetBytes(32)"
		"`$hash.Dispose(); `$hash = `$null"
	}
	if($KeyBytes)
	{
		$Local:PSDefaultParameterValues['ConvertTo-PowerShell.ps1:Key'] = $KeyBytes
		$keyopt = ' -Key $key'
		$dpapiwarn = ''
		$Script:PSDefaultParameterValues['ConvertFrom-SecureString:Key'] = $KeyBytes
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

	filter Format-WrapString
	{
		Write-Debug "Format-WrapString '$_' -Width $Width"
		for($i = 0; ($i+$Width) -lt $_.Length; $i += $Width) {$_.Substring($i,$Width)}
		if($_.Length % $Width) {$_.Substring($_.Length - ($_.Length % $Width))}
	}

	$typealias = @{}
	(Get-TypeAccelerators.ps1).GetEnumerator() |% {$typealias[$_.Value.FullName] = $_.Key}
	$typealias['System.Int16'] = 'short'
	$typealias['System.Int32'] = 'int'
	$typealias['System.Int64'] = 'long'
	filter Format-ParameterType
	{
		$type = $_.ParameterType.FullName
		if($typealias.ContainsKey($type)) {$type = $typealias[$type]}
		"[$type]"
	}

	filter Format-ParameterAttribute
	{
		Import-Variables.ps1 $_
		$name = $_.GetType().Name -replace 'Attribute\z',''
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
			Alias {"[Alias($(($AliasNames |ConvertTo-PowerShell.ps1 -SkipInitialIndent) -join ','))]"}
			ValidateCount {"[$name($MinLength,$MaxLength)]"}
			ValidateDrive {"[$name($(($ValidRootDrives |ConvertTo-PowerShell.ps1 -SkipInitialIndent) -join ','))]"}
			ValidateLength {"[$name($MinLength,$MaxLength)]"}
			ValidatePattern {"[$name('$($RegexPattern -replace "'","''")')]"}
			ValidateRange {"[$name($MinRange,$MaxRange)]"}
			ValidateScript {"[$name({$ScriptBlock})]"}
			ValidateSet {"[$name($(($ValidValues |ConvertTo-PowerShell.ps1 -SkipInitialIndent) -join ','))]"}
			default {"[$name()]"}
		}
	}

	function Format-Children($InputObject,[switch]$UseKeys)
	{
		if($InputObject -eq $null) {return}
		$(if($UseKeys){$InputObject.Keys}else{Get-Member -InputObject $InputObject -MemberType Properties |foreach Name}) |
			where {$_ -notmatch '\W'} |
			foreach {"$IndentBy$_ = $(ConvertTo-PowerShell.ps1 $InputObject.$_ -Indent "$tab$IndentBy" -SkipInitialIndent)"}
	}
}
Process
{
	if($null -eq $Value)
	{ "$itab`$null" }
	elseif($Value -is [bool])
	{ "$itab`$$Value" }
	elseif([int],[long],[byte],[decimal],[double],[float],[short],[sbyte],[uint16],[uint32],[uint64],[bigint] -contains $Value.GetType())
	{
		$number,$unit = $Value,''
		if($number -ge 1KB)
		{
			for($magnitude = 1LKB; $magnitude -le 1PB -and !($Value % $magnitude); $magnitude *= 1LKB)
			{
				$number = $Value / $magnitude
				$unit = $units[$magnitude]
			}
		}
		$suffix,$prefix =
			if($Value -is [int]) {}
			elseif($Value -is [long]) { 'L' }
			elseif($Value -is [decimal]) { 'd' }
			elseif($Value -is [bigint])
			{
				if($PSVersionTable.PSVersion.Major -lt 7) { "'","[bigint]'" }
				else { 'n' }
			}
			elseif($PSVersionTable.PSVersion.Major -lt 7) { '',"[$($Value.GetType().Name)]" }
			else
			{
				switch($Value.GetType().Name)
				{
					Byte   { 'uy' }
					Int16  { 's'  }
					SByte  { 'y'  }
					UInt16 { 'us' }
					UInt32 { 'u'  }
					UInt64 { 'ul' }
				}
			}
		"$itab$prefix$number$suffix$unit"
	}
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
	{@"
$itab@(
$($Value |% {ConvertTo-PowerShell.ps1 $_})
$tab)
"@}
	elseif($Value -is [securestring])
	{
		$password = (ConvertFrom-SecureString $Value |Format-WrapString) -join "' +$Newline${tabtab}'"
		"(ConvertTo-SecureString ($Newline${tabtab}'$password')$keyopt)$dpapiwarn"
	}
	elseif($Value -is [pscredential])
	{
		Write-Debug "Credential $($Value.UserName)"
		$username = "'$($Value.UserName -replace "'","''")'"
		$password =
			if(!$Value.Password) {'$null'}
			else
			{
				$p = (ConvertFrom-SecureString $Value.Password |Format-WrapString) -join "' +$Newline${tabtab}'"
				"(ConvertTo-SecureString ($Newline${tabtab}'$p')$keyopt)"
			}
		"${itab}New-Object pscredential $username,$password$dpapiwarn"
	}
	elseif($Value -is [Management.Automation.RuntimeDefinedParameterDictionary])
	{@"
${itab}Param(
$(($Value.GetEnumerator() |% {"$tabtab$(ConvertTo-PowerShell.ps1 $_.Value)"}) -join ',')
$tab)
"@}
	elseif($Value -is [Management.Automation.RuntimeDefinedParameter])
	{@"
$($Value.Attributes |Format-ParameterAttribute)
$itab$($Value |Format-ParameterType) `$$($Value.Name)
"@}
	elseif($Value -is [ScriptBlock])
	{ "{$Value}" }
	elseif($Value -is [Collections.Specialized.OrderedDictionary])
	{@"
$itab[ordered]@{
$tab$(Format-Children $Value -UseKeys)
$tab}
"@}
	elseif($Value -is [Hashtable])
	{@"
$itab@{
$tab$(Format-Children $Value -UseKeys)
$tab}
"@}
	elseif($Value -is [xml])
	{ "[xml]$(Format-PSString $Value.OuterXml)" }
	elseif($Value -is [PSObject])
	{@"
$itab[pscustomobject]@{
$tab$(Format-Children $Value)
$tab}
"@}
	else
	{@"
$itab@{
$tab$(Format-Children $Value)
$tab}
"@}
}
