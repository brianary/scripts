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
    $release = $v4.GetValue('Release')
    Write-Verbose "v4 release $release"
    switch($release)
    { # see https://msdn.microsoft.com/en-us/library/hh925568.aspx
        378389 {$versions += Add-Version 'v4.5' $v4.GetValue('Version')}
        378675 {$versions += Add-Version 'v4.5.1' $v4.GetValue('Version')}
        378758 {$versions += Add-Version 'v4.5.1' $v4.GetValue('Version')}
        379893 {$versions += Add-Version 'v4.5.2' $v4.GetValue('Version')}
        393295 {$versions += Add-Version 'v4.6' $v4.GetValue('Version')}
        393297 {$versions += Add-Version 'v4.6' $v4.GetValue('Version')}
        394254 {$versions += Add-Version 'v4.6.1' $v4.GetValue('Version')}
        394271 {$versions += Add-Version 'v4.6.1' $v4.GetValue('Version')}
        394747 {$versions += Add-Version 'v4.6.2+preview' $v4.GetValue('Version')}
        394748 {$versions += Add-Version 'v4.6.2+preview' $v4.GetValue('Version')}
        394802 {$versions += Add-Version 'v4.6.2' $v4.GetValue('Version')}
        460798 {$versions += Add-Version 'v4.7' $v4.GetValue('Version')}
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
