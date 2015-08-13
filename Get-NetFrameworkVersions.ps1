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
[Alias('Server')][string]$ComputerName = $env:COMPUTERNAME
)

function ConvertTo-ComplexVersion([string]$Name,[string]$Version)
{New-Object psobject -Property ([ordered]@{Name=$Name;Version=[version]$Version})}

$hklm = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$ComputerName)
$ndp = $hklm.OpenSubKey('SOFTWARE\Microsoft\NET Framework Setup\NDP')

# get v1-v3.x
$ndp.GetSubKeyNames() |
    ? {$_ -like 'v[123].*'} |
    % {
        $k = $ndp.OpenSubKey($_)
        ConvertTo-ComplexVersion $_ $k.GetValue('Version')
        [void]$k.Dispose(); $k = $null
    }

# get v4.x
$v4 = $ndp.OpenSubKey('v4\Full')
try
{
    switch($v4.GetValue('Release'))
    { # see https://msdn.microsoft.com/en-us/library/hh925568.aspx
        378389 {ConvertTo-ComplexVersion 'v4.5' $v4.GetValue('Version')}
        378675 {ConvertTo-ComplexVersion 'v4.5.1' $v4.GetValue('Version')}
        378758 {ConvertTo-ComplexVersion 'v4.5.1' $v4.GetValue('Version')}
        379893 {ConvertTo-ComplexVersion 'v4.5.2' $v4.GetValue('Version')}
        393295 {ConvertTo-ComplexVersion 'v4.6' $v4.GetValue('Version')}
        393297 {ConvertTo-ComplexVersion 'v4.6' $v4.GetValue('Version')}
    }    
}
catch [ArgumentNullException]
{
    "Unable to open the version sub key"
}
finally
{
    if(!!$v4) {[void]$v4.Dispose(); $v4 = $null}
    [void]$hklm.Dispose(); $hklm = $null
    [void]$ndp.Dispose(); $ndp = $null
}


