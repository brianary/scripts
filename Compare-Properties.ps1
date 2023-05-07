<#
.SYNOPSIS
Compares the properties of two objects.

.INPUTS
System.Management.Automation.PSObject with properties to compare.

.OUTPUTS
System.Management.Automation.PSCustomObject for each relevant property comparison,
with these fields:

* PropertyName
* Reference
* Value
* Difference
* DifferentValue

.FUNCTIONALITY
Properties

.LINK
https://docs.microsoft.com/dotnet/api/system.management.automation.psmemberset

.EXAMPLE
Compare-Properties.ps1 (Get-PSProvider variable) (Get-PSProvider alias)

PropertyName   : ImplementingType
Reference      : True
Value          : Microsoft.PowerShell.Commands.VariableProvider
Difference     : True
DifferentValue : Microsoft.PowerShell.Commands.AliasProvider

PropertyName   : Name
Reference      : True
Value          : Variable
Difference     : True
DifferentValue : Alias

PropertyName   : Drives
Reference      : True
Value          : {Variable}
Difference     : True
DifferentValue : {Alias}
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Management.Automation.PSCustomObject])] Param(
# The base object to compare properties to.
[Parameter(Position=0)][PSObject] $ReferenceObject,
# The second object to compare the properties of.
[Parameter(Position=1,ValueFromPipeline=$true)][PSObject] $DifferenceObject,
# Indicates different values should be suppressed.
[switch] $ExcludeDifferent,
# Indicates equal values should be included.
[switch] $IncludeEqual
)

Begin
{
	[string[]] $referenceProperties = @()
	$referenceProperties += $ReferenceObject.PSObject.Properties.Match('*','Properties') |Select-Object -ExpandProperty Name
}
Process
{
	[string[]] $differenceProperties = @()
	$differenceProperties += $DifferenceObject.PSObject.Properties.Match('*','Properties') |Select-Object -ExpandProperty Name
	foreach($property in $referenceProperties)
	{
		$referenceValue = $ReferenceObject.$property
		if(!$DifferenceObject.PSObject.Properties.Match($property,'Properties').Count)
		{
			if(!$ExcludeDifferent)
			{
				[pscustomobject]@{
					PropertyName   = $property
					Reference      = $true
					Value          = $referenceValue
					Difference     = $false
					DifferentValue = $null
				}
			}
		}
		else
		{
			$differentValue = $DifferenceObject.$property
			$comparison = [pscustomobject]@{
				PropertyName   = $property
				Reference      = $true
				Value          = $referenceValue
				Difference     = $true
				DifferentValue = $differentValue
			}
			if($referenceValue -eq $differentValue) {if($IncludeEqual) {$comparison}}
			elseif(!$ExcludeDifferent) {$comparison}
		}
	}
	if(!$ExcludeDifferent)
	{
		foreach($property in $differenceProperties |
			Where-Object {!$ReferenceObject.PSObject.Properties.Match($_,'Properties').Count})
		{
			[pscustomobject]@{
				PropertyName   = $property
				Reference      = $false
				Value          = $null
				Difference     = $true
				DifferentValue = $DifferenceObject.$property
			}
		}
	}
}
