<#
.SYNOPSIS
Use the calling script parameters to set Invoke-Sqlcmd defaults.

.DESCRIPTION
This script uses the ParameterSetName in use in the calling script to determine
which set of the calling script's parameters to set as defaults for the
Invoke-Sqlcmd cmdlet.

The same ParameterSetNames as Invoke-Sqlcmd are used, plus ConnectionName to
pull a connection string from the .NET configuration.

To use this script, add any or all of these parameter sets:

[CmdletBinding()] Param(
[Parameter(ParameterSetName='ByConnectionParameters',Mandatory=$true)][string]$ServerInstance,
[Parameter(ParameterSetName='ByConnectionParameters')][string]$Database,
[Parameter(ParameterSetName='ByConnectionString',Mandatory=$true)][string]$ConnectionString,
[Parameter(ParameterSetName='ByConnectionName',Mandatory=$true)][string]$ConnectionName
# ...
)

Or, if you wish to support Use-SqlcmdParams.ps1 in scripts that call your script:

[CmdletBinding()] Param(
[Parameter(ParameterSetName='ByConnectionParameters')][string]$ServerInstance = $PSDefaultParameterValues['Invoke-Sqlcmd:ServerInstance'],
[Parameter(ParameterSetName='ByConnectionParameters')][string]$Database = $PSDefaultParameterValues['Invoke-Sqlcmd:Database'],
[Parameter(ParameterSetName='ByConnectionString',Mandatory=$true)][string]$ConnectionString,
[Parameter(ParameterSetName='ByConnectionName',Mandatory=$true)][string]$ConnectionName
# ...
)

.COMPONENT
System.Configuration

.LINK
Import-Variables.ps1
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
[string]$HostName,
[int]$QueryTimeout,
[int]$ConnectionTimeout,
[int]$ErrorLevel,
[int]$SeverityLevel,
[int]$MaxCharLength,
[int]$MaxBinaryLength,
[switch]$DisableVariables,
[switch]$DisableCommands,
[switch]$EncryptConnection
)

function Get-SqlcmdParameterSet($ParameterSetName)
{
    switch($ParameterSetName)
    {
        ByConnectionParameters {@{'Invoke-Sqlcmd:ServerInstance'=$ServerInstance;'Invoke-Sqlcmd:Database'=$Database}}
        ByConnectionString     {@{'Invoke-Sqlcmd:ConnectionString'=$ConnectionString}}
        ByConnectionName
        {
            try{[void][Configuration.ConfigurationManager]}catch{Add-Type -as System.Configuration} # get access to the config connection strings
            @{'Invoke-Sqlcmd:ConnectionString'=[Configuration.ConfigurationManager]::ConnectionStrings[$ConnectionName].ConnectionString}
        }
        default
        {
            if($ServerInstance)        {Get-SqlcmdParameterSet 'ByConnectionParameters'}
            elseif($ConnectionStriong) {Get-SqlcmdParameterSet 'ByConnectionString'}
            elseif($ConnectionName)    {Get-SqlcmdParameterSet 'ByConnectionName'}
            else {throw "${ParameterSetName}: not a SQL connection parameter set and couldn't find a defining parameter"}
        }
    }
}

Get-Variable -Scope 1 -Name PSBoundParameters -ValueOnly -EA SilentlyContinue |Import-Variables.ps1
$caller = Get-Variable -Scope 1 -Name PSCmdlet -ValueOnly -EA SilentlyContinue
if(!$caller){throw 'Calling script must start with [CmdletBinding()] Param( <# connection params #> ). See help.'}
$value = Get-SqlcmdParameterSet $caller.ParameterSetName
foreach($param in 'HostName','QueryTimeout','ConnectionTimeout','ErrorLevel','SeverityLevel','MaxCharLength','MaxBinaryLength','DisableVariables','DisableCommands','EncryptConnection')
{
    if($val = Get-Variable $param -ValueOnly -EA SilentlyContinue) {$value.Add("Invoke-Sqlcmd:$param",$val)}
    elseif($val = Get-Variable $param -Scope 1 -ValueOnly -EA SilentlyContinue) {$value.Add("Invoke-Sqlcmd:$param",$val)}
}
Write-Verbose "Params: $(ConvertTo-Json $value -Compress)"
$defaults = Get-Variable -Scope 1 -Name PSDefaultParameterValues -EA SilentlyContinue
try { [void]$value.Keys } catch { gm -i $value }
if($defaults) {$value.Keys |? {$value.$_ -and $defaults.Value.Contains($_)} |% {$defaults.Value.Remove($_)}; $defaults.Value += $value}
else {Set-Variable -Scope 1 -Name PSDefaultParameterValues -Value $value}
