<#
.Synopsis
    Locates a command.

.Description
    Returns the full path to an application found in a directory in $env:Path,
    optionally with an extension from $env:PathExt.
    
.Parameter ApplicationName
    The name of the executable program to look for in the $env:Path directories,
    if the extension is omitted, $env:PathExt will be used to find one.

.Link
    Get-Command

.Example
    Get-CommandPath.ps1 telnet


    C:\WINDOWS\system32\telnet.exe
#>

#requires -version 3
[CmdletBinding()]Param(
[Parameter(Position=0,Mandatory=$true)][Alias("an")][string[]]$ApplicationName
)
$cmd = Get-Command $ApplicationName
if($cmd -is [Management.Automation.ApplicationInfo]) {$cmd.Path}
elseif($cmd -is [Management.Automation.AliasInfo]) {$cmd.Definition}
else {Write-Error "$ApplicationName is $($cmd.GetType().FullName)"}
