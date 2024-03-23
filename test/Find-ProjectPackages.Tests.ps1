<#
.SYNOPSIS
Tests finding modules used in projects.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Find-ProjectPackages' -Tag Find-ProjectPackages -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Find modules used in projects' -Tag FindProjectPackages,Find,ProjectPackages {
		It "Finds an installed package" {
			Push-Location TestDrive:
			dotnet new console
			Find-ProjectPackages.ps1 * |Should -BeNullOrEmpty
			dotnet add package Serilog
			$packages = dotnet list package --format json |ConvertFrom-Json
			$found = Find-ProjectPackages.ps1 Serilog*
			$found.name |Should -BeExactly $packages.projects.frameworks.topLevelPackages.id
			Pop-Location
		}
	}

}
