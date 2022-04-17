<#
.SYNOPSIS
Locates a command.

.DESCRIPTION
Returns the full path to an application found in a directory in $env:Path,
optionally with an extension from $env:PathExt.

.PARAMETER ApplicationName
The name of the executable program to look for in the $env:Path directories,
if the extension is omitted, $env:PathExt will be used to find one.

.PARAMETER FindAllInPath
Indicates that every directory in the Path should be searched for the command.

.INPUTS
System.String of commands to get the location details of.

.OUTPUTS
System.String of location details for the specified commands that were found.

.LINK
Get-Command

.EXAMPLE
Get-CommandPath.ps1 powershell

C:\windows\System32\WindowsPowerShell\v1.0\powershell.exe

.EXAMPLE
Get-CommandPath.ps1 dotnet -FindAllInPath

C:\Program Files\dotnet\dotnet.exe
C:\Program Files (x86)\dotnet\dotnet.exe
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
[Alias('Name','AN')][string[]] $ApplicationName,
[switch] $FindAllInPath
)
Process
{
    if($FindAllInPath)
    {
        $files =
            if([io.path]::GetExtension($ApplicationName)) {$ApplicationName}
            else {$env:PATHEXT.ToLower() -split ';' |foreach {[io.path]::ChangeExtension($ApplicationName,$_)}}
        Write-Verbose "Searching Path for $($files -join ', ')"
        foreach($p in $env:Path -split ';')
        {
            $files |
                foreach {Join-Path $p $_} |
                where {Test-Path $_ -Type Leaf}
        }
    }
    else
    {
        foreach($cmd in Get-Command $ApplicationName)
        {
            if($cmd -is [Management.Automation.ApplicationInfo]) {$cmd.Path}
            elseif($cmd -is [Management.Automation.ExternalScriptInfo]) {$cmd.Path}
            elseif($cmd -is [Management.Automation.AliasInfo]) {$cmd.Definition}
            else {Write-Error "$ApplicationName is $($cmd.GetType().FullName)"}
        }
    }
}
