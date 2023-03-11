<#
.SYNOPSIS
Tests Enables ANSI terminal colors.
#>

Describe 'Enable-AnsiColor' -Tag Enable-AnsiColor {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Enables ANSI terminal colors.' -Tag EnableAnsiColor,Enable,AnsiColor {
		It "Sets OutputRendering" {
			Param([string] $OutputRendering)
			$PSStyle.OutputRendering = 'PlainText'
			Enable-AnsiColor.ps1 -HostOnly
			$PSStyle.OutputRendering |Should -Be 'Host'
			Enable-AnsiColor.ps1
			$PSStyle.OutputRendering |Should -Be 'Ansi'
		}
	}
}
