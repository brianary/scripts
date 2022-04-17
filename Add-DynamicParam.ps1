<#
.SYNOPSIS
Adds a dynamic parameter to a script, within a DynamicParam block.

.PARAMETER Name
The name of the parameter.

.PARAMETER Type
The data type of the parameter.

.PARAMETER Position
The position of the parameter when not specifying the parameter names.

.PARAMETER ParameterSetName
The name of the set of parameters this parameter belongs to.

.PARAMETER ValidateCount
The valid number of values for a parameter that accepts a collection.
A range can be specified with a list of two integers.

.PARAMETER ValidateDrive
Valid root drive(s) for parameters that accept paths.

.PARAMETER ValidateLength
The valid length for a string parameter.
A range can be specified with a list of two integers.

.PARAMETER ValidatePattern
The valid regular expression pattern to match for a string parameter.

.PARAMETER ValidateRange
The valid range of values for a numeric parameter.

.PARAMETER ValidateScript
A script block to validate a parameter's value.
Any true result will validate the value, any false result will reject it.

.PARAMETER ValidateSet
A set of valid values for the parameter.
This will enable tab-completion.

.PARAMETER NotNull
Requires parameter to be non-null.

.PARAMETER NotNullOrEmpty
Requires parameter to be non-null and non-empty.

.PARAMETER TrustedData
Requires the parameter value to be Trusted data.

.PARAMETER UserDrive
Requires a path parameter to be on a User drive.

.PARAMETER Mandatory
Indicates a required parameter.

.PARAMETER ValueFromPipeline
Indicates a parameter that can accept values from the pipeline.

.PARAMETER ValueFromPipelineByPropertyName
Indicates a parameter that can accept values from the pipeline by matching the property name of pipeline objects to the
parameter name or alias.

.INPUTS
System.Object[] a list of possible values for this parameter to validate against.

.EXAMPLE
DynamicParam { Add-DynamicParam.ps1 Path string -Mandatory; $DynamicParams } Process { Import-Variables.ps1 $PSBoundParameters; ... }
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
[Parameter(Position=0,Mandatory=$true)][string] $Name,
[Parameter(Position=1)][type] $Type,
[int] $Position = -2147483648,
[string[]] $ParameterSetName = '__AllParameterSets',
[string[]] $Alias,
[Alias('Count')][ValidateCount(1,2)][int[]] $ValidateCount,
[string[]] $ValidateDrive,
[Alias('Length')][ValidateCount(1,2)][int[]] $ValidateLength,
[Alias('Match','Pattern')][string] $ValidatePattern,
[Alias('Range')][ValidateCount(2,2)][int[]] $ValidateRange,
[ScriptBlock] $ValidateScript,
[Parameter(ValueFromPipeline=$true)][Alias('Values')][object[]] $ValidateSet,
[switch] $NotNull,
[switch] $NotNullOrEmpty,
[switch] $TrustedData,
[switch] $UserDrive,
[Alias('Required')][switch] $Mandatory,
[Alias('Pipeline')][switch] $ValueFromPipeline,
[Alias('PipelineProperties','PipeName')][switch] $ValueFromPipelineByPropertyName,
[Alias('RemainingArgs')][switch] $ValueFromRemainingArguments
)
End
{
	$DynamicParams = Get-Variable DynamicParams -Scope 1 -ErrorAction SilentlyContinue
	if($null -eq $DynamicParams)
	{
		$DynamicParams = New-Object Management.Automation.RuntimeDefinedParameterDictionary
		$DynamicParams = New-Variable DynamicParams $DynamicParams -Scope 1 -PassThru
	}
	$atts = New-Object Collections.ObjectModel.Collection[System.Attribute]
	foreach($set in $ParameterSetName)
	{
		$att = New-Object Management.Automation.ParameterAttribute -Property @{
			Position                        = $Position
			ParameterSetName                = $ParameterSetName
			Mandatory                       = $Mandatory
			ValueFromPipeline               = $ValueFromPipeline
			ValueFromPipelineByPropertyName = $ValueFromPipelineByPropertyName
			ValueFromRemainingArguments     = $ValueFromRemainingArguments
		}
		$atts.Add($att)
	}
	if($Alias) {$atts.Add((New-Object Management.Automation.AliasAttribute $Alias))}
	if($NotNull) {$atts.Add((New-Object Management.Automation.ValidateNotNullAttribute))}
	if($NotNullOrEmpty) {$atts.Add((New-Object Management.Automation.ValidateNotNullOrEmptyAttribute))}
	if($ValidateCount)
	{
		if($ValidateCount.Length -eq 1) {$ValidateCount += $ValidateCount[0]}
		$atts.Add((New-Object Management.Automation.ValidateCountAttribute $ValidateCount))
	}
	if($ValidateDrive) {$atts.Add((New-Object Management.Automation.ValidateDriveAttribute $ValidateDrive))}
	if($ValidateLength)
	{
		if($ValidateLength.Length -eq 1) {$ValidateLength += $ValidateLength[0]}
		$atts.Add((New-Object Management.Automation.ValidateLengthAttribute $ValidateLength))
	}
	if($ValidatePattern) {$atts.Add((New-Object Management.Automation.ValidatePatternAttribute $ValidatePattern))}
	if($ValidateRange) {$atts.Add((New-Object Management.Automation.ValidateRangeAttribute $ValidateRange))}
	if($ValidateScript) {$atts.Add((New-Object Management.Automation.ValidateScriptAttribute $ValidateScript))}
	if($input) {$ValidateSet = $input}
	if($ValidateSet) {$atts.Add((New-Object Management.Automation.ValidateSetAttribute $ValidateSet))}
	if($TrustedData) {$atts.Add((New-Object Management.Automation.ValidateTrustedDataAttribute))}
	if($UserDrive) {$atts.Add((New-Object Management.Automation.ValidateUserDriveAttribute))}
	$param = New-Object Management.Automation.RuntimeDefinedParameter ($Name,$Type,$atts)
	$DynamicParams.Value.Add($Name,$param)
}
