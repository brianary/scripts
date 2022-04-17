<#
.SYNOPSIS
Convert a CimInstance object to a PSObject.

.PARAMETER InputObject
The CimInstance object to convert to a PSObject.

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
[Parameter(Position=0,ValueFromPipeline=$true)]
[Microsoft.Management.Infrastructure.CimInstance] $InputObject
)
Process
{
	$value = @{}
	foreach($name in $InputObject.CimClass.CimClassProperties)
	{
		$value[$name] =
			switch($InputObject.$name)
			{
				Instance      {$InputObject.$name |ConvertFrom-CimInstance.ps1}
				InstanceArray {@($InputObject.$name |ConvertFrom-CimInstance.ps1)}
				default       {$InputObject.$name}
			}
	}
	[pscustomobject]$value
}
