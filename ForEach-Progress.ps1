<#
.Synopsis
	Performs an operation against each item in a collection of input objects, with a progress bar.

.Parameter Activity
	The progress title text to display.

.Parameter Status
	A script block to generate status text from each $PSItem ($_).

.Parameter Process
	A script block to execute for each $PSItem ($_).

.Parameter InputObject
	An item to process.

.Inputs
	System.Management.Automation.PSObject to process.

.Example
	1..10 |ForEach-Progress.ps1 -Activity 'Testing' {"$_"} {Write-Host "item: $_"; sleep 2}
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string] $Activity,
[Parameter(Position=1,Mandatory=$true)][scriptblock] $Status,
[Parameter(Position=2,Mandatory=$true)][scriptblock] $Process,
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][psobject] $InputObject
)
End
{
	[psobject[]] $values = $input
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
