<#
.Synopsis
    Locates a command.

.Description
    Returns the full path to an application found in a directory in $env:Path,
    optionally with an extension from $env:PathExt.
    
.Parameter ApplicationName
    The name of the executable program to look for in the $env:Path directories,
    if the extension is omitted, $env:PathExt will be used to find one.

.Inputs
    System.String[] of commands to get the location details of.

.Outputs
    System.String[] of location details for the specified commands that were found.

.Link
    Get-Command

.Example
    Get-CommandPath.ps1 powershell

    C:\windows\System32\WindowsPowerShell\v1.0\powershell.exe
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string[]])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
[Alias('Name','AN')][string[]]$ApplicationName
)
Process
{
    foreach($cmd in Get-Command $ApplicationName)
    {
        if($cmd -is [Management.Automation.ApplicationInfo]) {$cmd.Path}
        elseif($cmd -is [Management.Automation.ExternalScriptInfo]) {$cmd.Path}
        elseif($cmd -is [Management.Automation.AliasInfo]) {$cmd.Definition}
        else {Write-Error "$ApplicationName is $($cmd.GetType().FullName)"}
    }
}
