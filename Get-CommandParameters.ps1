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

CommandName                     : Write-Verbose
ParameterName                   : Message
ParameterType                   : System.String
TypeAlias                       : string
ParameterSets                   : {__AllParameterSets}
Mandatory                       : True
Position                        : 0
ValueFromPipelineByPropertyName : False
ValueFromPipeline               : True
SwitchParameter                 : False
IsDynamic                       : False

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
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Alias('Name')][string] $CommandName,
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
	$typeAlias = @{}
	Get-TypeAccelerators.ps1 |
		Where-Object Alias -NotMatch '\d\d\z' |
		ForEach-Object {$typeAlias[$_.Type.FullName] = $_.Alias}

	filter ConvertFrom-ParameterMetadata
	{
		[CmdletBinding()] Param(
		[Parameter(Position=0,Mandatory=$true)][string] $CommandName,
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][string] $Name,
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][type] $ParameterType,
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
		[Collections.Generic.Dictionary[string,Management.Automation.ParameterSetMetadata]] $ParameterSets,
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][bool] $IsDynamic,
		[Parameter(ValueFromPipelineByPropertyName=$true)][string[]] $Aliases,
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][attribute[]] $Attributes,
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][bool] $SwitchParameter
		)
		$paramAtts = $Attributes |Where-Object {$_ -is [Management.Automation.ParameterAttribute]}
		return [pscustomobject]@{
			CommandName                     = $CommandName
			ParameterName                   = $Name
			ParameterType                   = $ParameterType
			TypeAlias                       = $ParameterType.FullName -replace '(\A\w+(?:\.\w+)*)(\W+)?',
				{$typeAlias.ContainsKey($_.Groups[1].Value) ? ($typeAlias[$_.Groups[1].Value]+$_.Groups[2].Value) : $_.Value}
			ParameterSets                   = $ParameterSets.Keys
			Mandatory                       = $paramAtts.Mandatory
			Position                        = $paramAtts.Position
			ValueFromPipelineByPropertyName = $paramAtts.ValueFromPipelineByPropertyName
			ValueFromPipeline               = $paramAtts.ValueFromPipeline
			SwitchParameter                 = $SwitchParameter
			IsDynamic                       = $IsDynamic
		}
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
			Select-Object -ExpandProperty Parameters |
			Where-Object Name -notin $excludeParams
		if($NamesOnly) {return $params |Select-Object -ExpandProperty Name}
		else {return $params |ConvertFrom-ParameterMetadata $CommandName}
	}
	else
	{
		if($NamesOnly) {return $cmd.Parameters.Keys |Where-Object {$_ -notin $excludeParams}}
		else
		{
			return $cmd.Parameters.Keys |
				Where-Object {$_ -notin $excludeParams} |
				ForEach-Object {$cmd.Parameters[$_] |ConvertFrom-ParameterMetadata $CommandName}
		}
	}
}
