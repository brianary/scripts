<#
.SYNOPSIS
Replaces the name of each environment variable embedded in the specified string with the string equivalent of the value of the variable, then returns the resulting string.

.PARAMETER Variable
The string to be expanded.

.LINK
https://docs.microsoft.com/dotnet/api/system.environment.expandenvironmentvariables

.EXAMPLE
Expand-EnvironmentVariables.ps1 %SystemRoot%\System32\cmd.exe

C:\WINDOWS\System32\cmd.exe
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $Value
)
Process { return [Environment]::ExpandEnvironmentVariables($Value) }
