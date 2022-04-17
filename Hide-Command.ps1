<#
.SYNOPSIS
Make a command unavailable.

.PARAMETER Name
The name of command to hide.

.PARAMETER CommandType
Specifies the types of commands that this cmdlet hides.

.INPUTS
System.String containing a command name, or an object with a Name of a command
and maybe a specific CommandType.

.LINK
Stop-ThrowError.ps1

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
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)][string] $Name,
[Parameter(ValueFromPipelineByPropertyName=$true)][Management.Automation.CommandTypes] $CommandType
)
Process
{
	$cmd = Get-Command @PSBoundParameters -ErrorAction SilentlyContinue
	if(!$cmd) {return}
	switch($cmd.CommandType)
	{
		Alias {Remove-Item "alias:$Name"}
		Function {Remove-Item "function:$Name"}
		Filter {Stop-ThrowError.ps1 "Filter $Name cannot be hidden" -OperationContext $cmd}
		Cmdlet {Remove-Module $cmd.Module}
		ExternalScript {Rename-Item $cmd.Source ([io.path]::ChangeExtension($cmd.Source,'ps1~'))}
		Application {Rename-Item $cmd.Source ([io.path]::ChangeExtension($cmd.Source,'ps1~'))}
		Script {Rename-Item $cmd.Source ([io.path]::ChangeExtension($cmd.Source,'ps1~'))}
		Configuration {Stop-ThrowError.ps1 "Configuration $Name cannot be hidden" -OperationContext $cmd}
		All {Stop-ThrowError.ps1 "Command $Name type 'All' cannot be hidden" -OperationContext $cmd}
		default {Stop-ThrowError.ps1 "Command $Name of unknown type cannot be hidden" -OperationContext $cmd}
	}
}
