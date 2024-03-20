<#
.SYNOPSIS
Tests searching installed programs.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Find-InstalledPrograms' -Tag Find-InstalledPrograms -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Searches installed programs' -Tag FindInstalledPrograms,Find,InstalledPrograms,Programs `
		-Skip:(!(([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).`
			IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
		It "Finds PowerShell installation" {
			$found = Find-InstalledPrograms.ps1 %powershell%
			$found.Name |Should -BeLike *PowerShell*
			$found.Caption |Should -BeLike *PowerShell*
			$found.Vendor |Should -BeLike *Microsoft*
		}
	}
}
