<#
.Synopsis
    Use the calling script parameters to set Invoke-Sqlcmd defaults.

.Description
    This script uses the ParameterSetName in use in the calling script to determine
    which set of the calling script's parameters to set as defaults for the
    Invoke-Sqlcmd cmdlet.

    The same ParameterSetNames as Invoke-Sqlcmd are used, plus ConnectionName to
    pull a connection string from the .NET configuration.
    
    To use this script, add any of these parameters:

    [Parameter(ParameterSetName='ByConnectionParameters',Mandatory=$true)][string]$ServerInstance,
    [Parameter(ParameterSetName='ByConnectionParameters',Mandatory=$true)][string]$Database,
    [Parameter(ParameterSetName='ByConnectionString',Mandatory=$true)][string]$ConnectionString,
    [Parameter(ParameterSetName='ByConnectionName',Mandatory=$true)][string]$ConnectionName

.Link
    Import-Variables.ps1
#>

#Requires -Version 3
[CmdletBinding()] Param(
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
$params = Get-Variable -Scope 1 -Name PSBoundParameters -ValueOnly -EA SilentlyContinue
Import-Variables.ps1 $params
$caller = Get-Variable -Scope 1 -Name PSCmdlet -ValueOnly -EA SilentlyContinue
$value = 
    switch($caller.ParameterSetName)
    {
        ByConnectionParameters {@{'Invoke-Sqlcmd:ServerInstance'=$ServerInstance;'Invoke-Sqlcmd:Database'=$Database}}
        ByConnectionString     {@{'Invoke-Sqlcmd:ConnectionString'=$ConnectionString}}
        ByConnectionName
        {
            try{[void][Configuration.ConfigurationManager]}catch{Add-Type -as System.Configuration} # get access to the config connection strings
            @{'Invoke-Sqlcmd:ConnectionString'=[Configuration.ConfigurationManager]::ConnectionStrings[$ConnectionName].ConnectionString}
        }
    }
foreach($param in 'HostName','QueryTimeout','ConnectionTimeout','ErrorLevel','SeverityLevel','MaxCharLength','MaxBinaryLength','DisableVariables','DisableCommands','EncryptConnection')
{
    if($val = Get-Variable $param -ValueOnly -EA SilentlyContinue) {$value.Add($param,$val)}
    elseif($val = Get-Variable $param -Scope 1 -ValueOnly -EA SilentlyContinue) {$value.Add($param,$val)}
}
Write-Verbose "Params: $(ConvertTo-Json $value -Compress)"
$defaults = Get-Variable -Scope 1 -Name PSDefaultParameterValues -EA SilentlyContinue
if($defaults) {$value.Keys |? {$value.$_ -and $defaults.Value.Contains($_)} |% {$defaults.Value.Remove($_)}; $defaults.Value += $value}
else {Set-Variable -Scope 1 -Name PSDefaultParameterValues -Value $value}
