<#
.SYNOPSIS
Tests converting a CimInstance object to a PSObject.
#>

Describe 'ConvertFrom-CimInstance' -Tag ConvertFrom-CimInstance {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir ConvertFrom-CimInstance.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Comment-based help' -Tag CommentHelp {
		It "Should produce help object" {
			Get-Help $ScriptName |Should -Not -BeOfType string `
				-Because 'Get-Help should not fall back to the default help string'
		}
	}
	Context 'Script style' -Tag Style {
		It "Should follow best practices for style" {
			Invoke-ScriptAnalyzer -Path $ScriptName -Severity Warning |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly $null -Because 'there should be no style warnings'
			Invoke-ScriptAnalyzer -Path $ScriptName -Severity Error |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly $null -Because 'there should be no style errors'
		}
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
		It "Convert a Scheduled Task CIM instance into a PSCustomObject" {
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
