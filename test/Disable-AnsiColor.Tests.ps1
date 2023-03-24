<#
.SYNOPSIS
Tests disabling ANSI terminal colors.
#>

Describe 'Disable-AnsiColor' -Tag Disable-AnsiColor {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Disables ANSI terminal colors' -Tag DisableAnsiColor,Disable,AnsiColor {
		It "Sets OutputRendering" {
			Param([string] $OutputRendering)
			$PSStyle.OutputRendering = 'Ansi'
			Disable-AnsiColor.ps1
			$PSStyle.OutputRendering |Should -Be 'PlainText'
			Disable-AnsiColor.ps1 -HostOnly
			$PSStyle.OutputRendering |Should -Be 'Host'
		}
	}
}
