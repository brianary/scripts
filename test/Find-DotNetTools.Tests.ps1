<#
.SYNOPSIS
Tests searching for matching dotnet tools.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Find-DotNetTools' -Tag Find-DotNetTools -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Returns a list of matching dotnet tools' -Tag FindDotNetTools,Find,DotNetTools,DotNet {
		It "Finds .NET Interactive" {
			Find-DotNetTools.ps1 microsoft.dotnet-interactive |
				Select-Object -First 1 -ExpandProperty PackageName |
				Should -BeExactly microsoft.dotnet-interactive
		}
		It "Finds Microsoft packages" {
			@(Find-DotNetTools.ps1 microsoft).Count |Should -BeGreaterThan 0
		}
	}
}
