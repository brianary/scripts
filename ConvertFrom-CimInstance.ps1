<#
.Synopsis
    Convert a CimInstance object to a PSObject.

.Parameter InputObject
    The CimInstance object to convert to a PSObject.

.Inputs
    Microsoft.Management.Infrastructure.CimInstance to convert to a PSObject.

.Outputs
    PSObject converted from the CimInstance entered.

.Example
    $tasks = Get-ScheduledTask |ConvertFrom-CimInstance.ps1

    Gets the scheduled tasks as PSObjects that support tab completion and can be serialized and exported.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,ValueFromPipeline=$true)]
[Microsoft.Management.Infrastructure.CimInstance] $InputObject
)
Process
{
    $value = @{}
    foreach($prop in $InputObject.CimInstanceProperties)
    {
        $value[$prop.Name] =
            switch($prop.CimType)
            {
                Instance      {$prop.Value |ConvertFrom-CimInstance.ps1}
                InstanceArray {@($prop.Value |ConvertFrom-CimInstance.ps1)}
                default       {$prop.Value}
            }
    }
    [pscustomobject]$value
}
