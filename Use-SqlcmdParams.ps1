<#
.Synopsis
    Use the calling script parameters to set Invoke-Sqlcmd defaults.

.Description
    This script uses the ParameterSetName in use in the calling script to determine
    which set of the calling script's parameters to set as defaults for the
    Invoke-Sqlcmd cmdlet.

    The same ParameterSetNames as Invoke-Sqlcmd are used, with one additional:

    * ByConnectionParameter: ServerInstance and Database
    * ByConnectionString: ConnectionString
    * ByConnectionName: ConnectionName (sets ConnectionString default from config)

.Link
    Export-TableMerge.ps1

.Link
    Send-SqlReport.ps1

.Link
    Repair-DatabaseConstraintNames.ps1

.Link
    Find-SqlDeprecatedLargeValueTypes.ps1

.Link
    Import-Variables.ps1
#>

#Requires -Version 3
[CmdletBinding()] Param()
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
$defaults = Get-Variable -Scope 1 -Name PSDefaultParameterValues -EA SilentlyContinue
if($defaults) {$value.Keys |? {$value.$_ -and $defaults.Value.Contains($_)} |% {$defaults.Value.Remove($_)}; $defaults.Value += $value}
else {Set-Variable -Scope 1 -Name PSDefaultParameterValues -Value $value}
