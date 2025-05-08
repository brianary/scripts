<#
.SYNOPSIS
Returns the commands used by the specified script.

.FUNCTIONALITY
Scripts

.INPUTS
System.String containing the path to a script file to parse.

.OUTPUTS
System.Management.Automation.CommandInfo for each command parsed from the file.

.LINK
https://learn.microsoft.com/dotnet/api/system.management.automation.language.parser.parsefile

.LINK
Get-Command

.EXAMPLE
Select-ScriptCommands.ps1 Select-ScriptCommands.ps1

CommandType  Name                Version    Source
-----------  ----                -------    ------
Cmdlet       Out-Null            7.5.0.500  Microsoft.PowerShell.Core
Cmdlet       Where-Object        7.5.0.500  Microsoft.PowerShell.Core
Cmdlet       Select-Object       7.0.0.0    Microsoft.PowerShell.Utility
Cmdlet       Get-Command         7.5.0.500  Microsoft.PowerShell.Core
Cmdlet       Resolve-Path        7.0.0.0    Microsoft.PowerShell.Management
Filter       Get-ScriptCommands
#>

#Requires -Version 7
[CmdletBinding()][OutputType([System.Management.Automation.CommandInfo])] Param(
# A script file path (wildcards are accepted).
[Parameter(Position=0,ValueFromPipeline=$true)][string] $Path,
# Specifies the types of commands that this cmdlet gets.
[Management.Automation.CommandTypes] $CommandType
)
Begin
{
    $Script:parseErrors = [Management.Automation.Language.ParseError[]]@()
    $Script:tokens = [Management.Automation.Language.Token[]]@()
    filter Get-ScriptCommands
    {
        [CmdletBinding()] Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string] $Path
        )
        [Management.Automation.Language.Parser]::ParseFile($Path,
            [ref]$Script:tokens, [ref]$Script:parseErrors) |Out-Null
        $commands = $Script:tokens |
            Where-Object TokenFlags -eq 'CommandName' |
            Select-Object -Unique -ExpandProperty Value |
            Get-Command -ErrorAction Ignore
        return !$CommandType ? $commands : ($commands |Where-Object CommandType -eq $CommandType)
    }
}
Process
{
    Resolve-Path $Path |Get-ScriptCommands
}
