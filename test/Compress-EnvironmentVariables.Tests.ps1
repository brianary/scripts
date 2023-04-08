<#
.SYNOPSIS
Tests replacing each of the longest matching parts of a string with an embedded environment variable with that value.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Compress-EnvironmentVariables' -Tag Compress-EnvironmentVariables -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Replaces each of the longest matching parts of a string with an embedded environment variable with that value' `
		-Tag CompressEnvironmentVariables,Compress,EnvironmentVariables {
		It "For '<Value>', should return '<Result>'" -TestCases @(
			@{ Value ="[$env:APPDATA]"; Result = '[%APPDATA%]' }
			@{ Value ="[$env:COMPUTERNAME]"; Result = '[%COMPUTERNAME%]' }
			@{ Value ="$env:TEMP\tempdata"; Result = '%TEMP%\tempdata' }
		) {
			Param([string] $Value, [string] $Result)
			Compress-EnvironmentVariables.ps1 $Value |Should -Be $Result
		}
	}
}
