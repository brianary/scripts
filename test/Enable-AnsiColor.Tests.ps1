<#
.SYNOPSIS
Tests Enables ANSI terminal colors.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Enable-AnsiColor' -Tag Enable-AnsiColor -Skip:$skip {
	BeforeAll {
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
