<#
.Synopsis
    Determine which .NET Frameworks are installed on the requested system.

.Parameter ComputerName
    The computer to list the installed .NET Frameworks for.

.Component
    Microsoft.Win32.RegistryKey
#>

#requires -version 3
[CmdletBinding()] Param(
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
        '460806' = 'v4.7+after-4.7'
        '460805' = 'v4.7+pre-win10cu'
        '460798' = 'v4.7+win10cu'
        '394806' = 'v4.6.2+pre-win10ann'
        '394802' = 'v4.6.2+win10ann'
        '394748' = 'v4.6.2-preview'
        '394747' = 'v4.6.2-preview'
        '394271' = 'v4.6.1+pre-win10'
        '394254' = 'v4.6.1+win10'
        '393297' = 'v4.6+pre-win10'
        '393295' = 'v4.6+win10'
        '379893' = 'v4.5.2'
        '378758' = 'v4.5.1+pre-win8.1'
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
