<#
.SYNOPSIS
Convert a CimInstance object to a PSObject.

.INPUTS
Microsoft.Management.Infrastructure.CimInstance to convert to a PSObject.

.OUTPUTS
PSObject converted from the CimInstance entered.

.EXAMPLE
$tasks = Get-ScheduledTask |ConvertFrom-CimInstance.ps1

Gets the scheduled tasks as PSObjects that support tab completion and can be serialized and exported.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Management.Automation.PSCustomObject])] Param(
# The CimInstance object to convert to a PSObject.
[Parameter(Position=0,ValueFromPipeline=$true)]
[Microsoft.Management.Infrastructure.CimInstance] $InputObject
)
Process
{
	$value = [ordered]@{'#CimClassName' = $InputObject.CimClass.CimClassName}
	foreach($name in $InputObject.CimClass.CimClassProperties)
	{
		if($null -eq $InputObject.$name) {continue}
		switch($InputObject.CimInstanceProperties[$name].CimType)
		{
			Instance      {$value[$name] = $InputObject.$name |ConvertFrom-CimInstance.ps1}
			InstanceArray {$value[$name] = [psobject[]]@($InputObject.$name |ConvertFrom-CimInstance.ps1)}
			default       {$value[$name] = $InputObject.$name}
		}
	}
	[pscustomobject]$value
}
