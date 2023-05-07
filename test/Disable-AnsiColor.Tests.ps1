<#
.SYNOPSIS
Tests disabling ANSI terminal colors.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Disable-AnsiColor' -Tag Disable-AnsiColor -Skip:$skip {
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

