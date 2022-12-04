<#
.SYNOPSIS
Performs an operation against each item in a collection of input objects, with a progress bar.

.INPUTS
System.Management.Automation.PSObject to process.

.FUNCTIONALITY
Progress

.EXAMPLE
1..10 |ForEach-Progress.ps1 -Activity 'Processing' {"$_"} {Write-Host "item: $_"; sleep 2}

Provides a progress indicator for a script block.

.EXAMPLE
1..10 |ForEach-Progress.ps1 |foreach {Write-Host "item: $_"; sleep 2}

Same as previous example, but adds a progress indicator within an existing pipeline.
#>

#Requires -Version 3
[CmdletBinding()] Param(
# The progress title text to display.
[Parameter(Position=0)][string] $Activity = 'Processing',
# A script block to generate status text from each $PSItem ($_).
[Parameter(Position=1)][scriptblock] $Status = {$_ |ConvertTo-Json -Compress},
# A script block to execute for each $PSItem ($_).
[Parameter(Position=2)][scriptblock] $Process = {$_},
# An item to process.
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][psobject] $InputObject
)
End
{
	[psobject[]] $values = if($input) {$input} else {@($InputObject)}
	$i,$max,$id = 0,($values.Length/100),(Get-Random)
	try
	{
		foreach($value in $values)
		{
			[Collections.Generic.List[psvariable]] $ctx = New-Object PSVariable _,$value
			$itemstatus = $Status.InvokeWithContext($null,$ctx,$value)[0]
			Write-Progress $Activity $itemstatus -Id $id -PercentComplete ($i++/$max)
			[Collections.Generic.List[psvariable]] $ctx = New-Object PSVariable _,$value
			$Process.InvokeWithContext($null,$ctx,$value)
		}
	}
	finally {Write-Progress $Activity -Id $id -Completed}
}
