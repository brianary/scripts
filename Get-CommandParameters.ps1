<#
.SYNOPSIS
Returns the parameters of the specified cmdlet.

.FUNCTIONALITY
Command

.LINK
Stop-ThrowError.ps1

.LINK
Get-Command

.EXAMPLE
Get-CommandParameters.ps1 Write-Verbose

Name            : Message
ParameterType   : System.String
ParameterSets   : {[__AllParameterSets, System.Management.Automation.ParameterSetMetadata]}
IsDynamic       : False
Aliases         : {Msg}
Attributes      : {, System.Management.Automation.AllowEmptyStringAttribute, System.Management.Automation.AliasAttribute}
SwitchParameter : False

.EXAMPLE
Get-CommandParameters.ps1 Out-Default -NamesOnly

Transcript
InputObject
#>

#Requires -Version 3
[CmdletBinding()]
[OutputType([string])]
Param(
# The name of a cmdlet.
[Parameter(Position=0,Mandatory=$true)][string] $CommandName,
# The name of a parameter set defined by the cmdlet.
[string] $ParameterSet,
# Return only the parameter names (otherwise)
[switch] $NamesOnly,
# Includes common parameters such as -Verbose and -WhatIf.
[switch] $IncludeCommon
)
Begin
{
	[string[]] $excludeParams =
		if($IncludeCommon) {@()}
		else
		{
			[string[]][System.Management.Automation.PSCmdlet]::CommonParameters +
				[string[]][System.Management.Automation.PSCmdlet]::OptionalCommonParameters
		}
}
Process
{
	$cmd = Get-Command -Name $CommandName -ErrorAction Ignore
	if(!$cmd) {Stop-ThrowError.ps1 "Cmdlet not found: $CommandName" -ParameterName CommandName}
	if($ParameterSet)
	{
		$params = $cmd.ParameterSets |
			Where-Object Name -eq $ParameterSet |
			ForEach-Object Parameters |
			Where-Object Name -notin $excludeParams
		if($NamesOnly) {return $params |ForEach-Object Name}
		else {return $params}
	}
	else
	{
		if($NamesOnly) {return $cmd.Parameters.Keys |Where-Object {$_ -notin $excludeParams}}
		else
		{
			return $cmd.Parameters.Keys |
				Where-Object {$_ -notin $excludeParams} |
				ForEach-Object {$cmd.Parameters[$_]}
		}
	}
}
