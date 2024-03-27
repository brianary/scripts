<#
.SYNOPSIS
Tests performing an operation against each item in a collection of input objects, with a progress bar.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'ForEach-Progress' -Tag ForEach-Progress -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Performs an operation against each item in a collection of input objects, with a progress bar' `
		-Tag ForEachProgress,ForEach,Progress {
		It "Displays progress" {
			Mock Write-Progress {}
			1..10 |ForEach-Progress.ps1 -Activity 'Processing' {"$_"} {"$_"}
			Assert-MockCalled -CommandName Write-Progress -Times 10
		}
	}
}
