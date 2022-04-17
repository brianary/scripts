<#
.SYNOPSIS
Determine which .NET Frameworks are installed on the requested system.

.PARAMETER ComputerName
The computer to list the installed .NET Frameworks for.

.OUTPUTS
System.Collections.Hashtable of semantic version names to version numbers
of .NET frameworks installed.

.COMPONENT
Microsoft.Win32.RegistryKey

.EXAMPLE
Get-DotNetFrameworkVersions.ps1

Name                           Value
----                           -----
v4.6.2+win10ann                4.6.1586
v3.5                           3.5.30729.4926
v2.0.50727                     2.0.50727.4927
v3.0                           3.0.30729.4926
#>

#Requires -Version 3
[CmdletBinding()][OutputType([hashtable])] Param(
[Alias('CN','Server')][string]$ComputerName = $env:COMPUTERNAME
)

function Add-Version([string]$Name,[string]$Version)
{if($Version){@{$Name=[version]$Version}}else{@{}}}

$hklm = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$ComputerName)
$ndp = $hklm.OpenSubKey('SOFTWARE\Microsoft\NET Framework Setup\NDP')

$versions = @{}
# get v1-v3.x
$ndp.GetSubKeyNames() |
	? {$_ -like 'v[123].*'} |
	% {
		$k = $ndp.OpenSubKey($_)
		$v = $k.GetValue('Version')
		Write-Verbose "Found '$_' subkey, version $v"
		$versions += Add-Version $_ $v
		[void]$k.Dispose(); $k = $null
	}

# get v4.x
$v4 = $ndp.OpenSubKey('v4\Full')
try
{
	[string]$release = $v4.GetValue('Release')
	Write-Verbose "v4 release $release"
	$name = [ordered]@{ # see https://msdn.microsoft.com/en-us/library/hh925568.aspx
		'528049' = 'v4.8'
		'528372' = 'v4.8+win10may2020'
		'528040' = 'v4.8+win10may2019'
		'461814' = 'v4.7.2'
		'461808' = 'v4.7.2+win10april2018'
		'461310' = 'v4.7.1'
		'461308' = 'v4.7.1+win10fcu'
		'460805' = 'v4.7'
		'460798' = 'v4.7+win10cu'
		'394806' = 'v4.6.2'
		'394802' = 'v4.6.2+win10ann'
		'394748' = 'v4.6.2-preview'
		'394747' = 'v4.6.2-preview'
		'394271' = 'v4.6.1'
		'394254' = 'v4.6.1+win10'
		'393297' = 'v4.6'
		'393295' = 'v4.6+win10'
		'379893' = 'v4.5.2'
		'378758' = 'v4.5.1'
		'378675' = 'v4.5.1+win8.1'
		'378389' = 'v4.5'
	}
	foreach($key in $name.Keys)
	{
		if($release -ge $key)
		{
			$versions += Add-Version $name.$key $v4.GetValue('Version')
			break
		}
	}
}
catch [ArgumentNullException]
{
	Write-Warning "Unable to open the version 4 sub key."
}
finally
{
	if($v4) {[void]$v4.Dispose(); $v4 = $null}
	[void]$hklm.Dispose(); $hklm = $null
	[void]$ndp.Dispose(); $ndp = $null
}

$versions
