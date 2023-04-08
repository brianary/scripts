<#
.SYNOPSIS
Tests converting a CimInstance object to a PSObject.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'ConvertFrom-CimInstance' -Tag ConvertFrom-CimInstance -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Convert a CimInstance object to a PSObject' `
		-Tag ConvertFromCimInstance,Convert,ConvertFrom,CimInstance {
		BeforeAll {
			Register-ScheduledTask -TaskName x -Description 'This is a test.' `
				-Action (New-ScheduledTaskAction -Execute pwsh -Argument 1) `
				-Trigger (New-ScheduledTaskTrigger -At (Get-Date).Date -Once)
		}
		AfterEach {
			try { Unregister-ScheduledTask -TaskName x -Confirm:$false -EA Stop }
			catch { Write-Warning "$_" }
		}
		It "Should convert a Scheduled Task CIM instance into a PSCustomObject" {
			$task = Get-ScheduledTask -TaskName x |ConvertFrom-CimInstance.ps1
			$task |Should -BeOfType pscustomobject
			$task.'#CimClassName' |Should -BeExactly MSFT_ScheduledTask
			$task.TaskName |Should -BeExactly x
			$task.Description |Should -BeExactly 'This is a test.'
			$task.State |Should -BeExactly Ready
			$act = $task.Actions
			$act |Should -BeOfType pscustomobject
			$act.'#CimClassName' |Should -BeExactly MSFT_TaskExecAction
			$act.Execute |Should -BeExactly pwsh
			$act.Arguments |Should -BeExactly '1'
			$trigger = $task.Triggers
			$trigger |Should -BeOfType pscustomobject
			$trigger.'#CimClassName' |Should -BeExactly MSFT_TaskTimeTrigger
			$trigger.Enabled |Should -BeTrue
			$trigger.StartBoundary |Should -BeLike (Get-Date -f 'yyyy-MM-dd\T*')
			$schedule = $trigger.Repetition
			$schedule |Should -BeOfType pscustomobject
			$schedule.'#CimClassName' |Should -BeExactly MSFT_TaskRepetitionPattern
		}
	}
}
