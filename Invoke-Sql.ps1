<#
.Synopsis
    Runs a SQL script with verbose output and without changing the directory.

.Description
    This is a wrapper around the SQLPS module's Invoke-Sqlcmd cmdlet, with protection against
    unpredictably changing the directory, and adding verbose output of the script.

    It'll also attempt to use Install-Sqlps.ps1 to automatically install SQLPS if it is missing.

    For full description of parameters and examples, see Invoke-Sqlcmd.

    Much of the implementation of these features comes from another script,
    Invoke-SqlcmdScript.ps1 to allow early catching of PSDrive changes that would be
    triggered by direct references to SQLPS and Invoke-Sqlcmd.

.Example
    Invoke-Sql -Query "SELECT GETDATE() AS TimeOfQuery;" -ServerInstance "MyComputer\MyInstance"


    TimeOfQuery
    -----------
    5/13/2010 8:49:43 PM

.Component
    SQLPS

.Link
    Invoke-SqlcmdScript.ps1

.Link
    Invoke-Sqlcmd

.Link
    https://msdn.microsoft.com/library/hh231286.aspx

.Link
    https://msdn.microsoft.com/library/cc281720.aspx

.Link
    http://www.microsoft.com/en-us/download/details.aspx?id=42295
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
[int]$MaxCharLength = 2147483647,
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

# store current directory
$oldpwd = $PWD # store the current location (importing SQLPS changes it)

# add defaults to bound params
foreach($key in $MyInvocation.MyCommand.Parameters.Keys)
{
    $value = Get-Variable $key -ValueOnly -EA SilentlyContinue
    if($value -and !$PSBoundParameters.ContainsKey($key)) {$PSBoundParameters[$key] = $value}
}

# run core cmdlet
& "$PSScriptRoot\Invoke-SqlcmdScript.ps1" @PSBoundParameters # splat-thru

# restore current directory if changed
if($oldpwd -ne $PWD) {Set-Location $oldpwd} # restore location if changed
