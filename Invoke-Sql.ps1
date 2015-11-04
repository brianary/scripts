<#
.Synopsis
    Runs a SQL script with verbose output and without changing the directory.

.Description
    This is a wrapper around the SQLPS module's Invoke-Sqlcmd cmdlet, with protection against
    unpredictably changing the directory, and adding verbose output of the script.

    It'll also attempt to use Install-Sqlps.ps1 to automatically install SQLPS if it is missing.

    For full description of parameters and examples, see Invoke-Sqlcmd.

.Example
    Invoke-Sql -Query "SELECT GETDATE() AS TimeOfQuery;" -ServerInstance "MyComputer\MyInstance"


    TimeOfQuery
    -----------
    5/13/2010 8:49:43 PM

.Link
    SQLPS

.Link
    Invoke-Sqlcmd

.Link
    https://msdn.microsoft.com/library/hh231286.aspx

.Link
    https://msdn.microsoft.com/library/cc281720.aspx
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(Position=1,Mandatory=$true)][string]$Query,
[switch]$AbortOnError,
[int]$ConnectionTimeout,
[string]$Database,
[switch]$DedicatedAdministratorConnection,
[switch]$DisableCommands,
[switch]$DisableVariables,
[switch]$EncryptConnection,
[int]$ErrorLevel,
[string]$HostName,
[switch]$IgnoreProviderContext,
[switch]$IncludeSqlUserErrors,
[string]$InputFile,
[int]$MaxBinaryLength,
[int]$MaxCharLength,
[string]$NewPassword,
[bool]$OutputSqlErrors,
[string]$Password,
[int]$QueryTimeout,
[Parameter(ValueFromPipeline=$true)][PSObject]$ServerInstance,
[int]$SeverityLevel,
[switch]$SuppressProviderContextWarning,
[string]$Username,
[string[]]$Variable
)

# import SQLPS
$oldpwd = $PWD # store the current location (importing SQLPS changes it)
# See https://connect.microsoft.com/SQLServer/feedback/details/1871239/requires-module-sqlps-or-import-module-sqlps-changes-pwd-to-sqlserver
try{Get-Command Invoke-Sqlcmd -EA Stop |Out-Null}
catch
{
    try{Import-Module SQLPS -EA Stop}
    catch
    {
        $installer = ls $PSScriptRoot -Recurse -Filter Install-Sqlps.ps1 |select -First 1 -ExpandProperty FullName
        if(!$installer) {Write-Error "You need to install SQLPS."}
        else {Start-Process -FilePath powershell.exe -ArgumentList '-NonInteractive','-NoProfile','-File',$installer -Verb RunAs}
    }
}
if($oldpwd -ne $PWD) {Set-Location $oldpwd} # restore location if changed

# show what's being used
$script:OFS = ", " # format verbose lists
@('ServerInstance','Database','HostName','InputFile','Variable','ConnectionTimeout',
    'ErrorLevel','MaxBinaryLength','MaxCharLength','QueryTimeout','SeverityLevel') |
    Get-Variable |? Value |% {Write-Verbose "$($_.Name): $($_.Value)"}
Write-Verbose "Query:`n$Query"
$switches = @('AbortOnError','DedicatedAdministratorConnection','DisableCommands',
    'DisableVariables','EncryptConnection','IgnoreProviderContext','IncludeSqlUserErrors',
    'OutputSqlErrors','SuppressProviderContextWarning') |? {Get-Variable $_ -ValueOnly}
if($switches) {Write-Verbose "Active switches: $switches"}
Remove-Variable OFS -Scope script # restore Output Field Separator

# run core cmdlet
Invoke-Sqlcmd @PSBoundParameters # splat-thru
