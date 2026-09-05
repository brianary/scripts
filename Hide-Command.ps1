<#
.SYNOPSIS
Make a command unavailable.

.INPUTS
System.String containing a command name, or an object with a Name of a command
and maybe a specific CommandType.

.FUNCTIONALITY
Command

.LINK
ModernConveniences\Stop-ThrowError

.LINK
Get-Command

.EXAMPLE
Hide-Command.ps1 Hide-Command.ps1

Renames the Hide-Command.ps1 script to Hide-Command.ps1~, making it unavailable.

.EXAMPLE
Hide-Command.ps1 mkdir

Removes the mkdir function.
#>

#Requires -Version 3
#Requires -Modules ModernConveniences
using module ModernConveniences
[CmdletBinding()] Param(
# The name of command to hide.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)][string] $Name,
# Specifies the types of commands that this cmdlet hides.
[Parameter(ValueFromPipelineByPropertyName=$true)][Management.Automation.CommandTypes] $CommandType
)
Process
{
	$cmd = Get-Command @PSBoundParameters -ErrorAction Ignore
	if(!$cmd) {return}
	switch($cmd.CommandType)
	{
		Alias {Remove-Item "alias:$Name"}
		Function {Remove-Item "function:$Name"}
		Filter {ModernConveniences\Stop-ThrowError "Filter $Name cannot be hidden" -OperationContext $cmd}
		Cmdlet {Remove-Module $cmd.Module}
		ExternalScript {Rename-Item $cmd.Source ([io.path]::ChangeExtension($cmd.Source,'ps1~'))}
		Application {Rename-Item $cmd.Source ([io.path]::ChangeExtension($cmd.Source,'ps1~'))}
		Script {Rename-Item $cmd.Source ([io.path]::ChangeExtension($cmd.Source,'ps1~'))}
		Configuration {ModernConveniences\Stop-ThrowError "Configuration $Name cannot be hidden" -OperationContext $cmd}
		All {ModernConveniences\Stop-ThrowError "Command $Name type 'All' cannot be hidden" -OperationContext $cmd}
		default {ModernConveniences\Stop-ThrowError "Command $Name of unknown type cannot be hidden" -OperationContext $cmd}
	}
}
