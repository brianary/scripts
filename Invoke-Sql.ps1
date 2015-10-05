<#
.Synopsis
    Runs a SQL script with verbose output and without changing the directory.

.Description
    This is a wrapper around the SQLPS module's Invoke-Sqlcmd cmdlet, with protection against
    unpredictably changing the directory, and adding verbose output of the script.

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
#requires -module SQLPS
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

$oldpwd = $PWD # store the location (sometimes Invoke-Sqlcmd changes it)
Invoke-Sqlcmd @PSBoundParameters # splat-thru
if($oldpwd -ne $PWD) {Set-Location $oldpwd} # restore location if changed
