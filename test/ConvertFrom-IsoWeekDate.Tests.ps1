<#
.SYNOPSIS
Tests Returns a DateTime object from an ISO week date string.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |
		Where-Object {$_.StartsWith($basename) -or $_.StartsWith('Format-Date')})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
Describe 'ConvertFrom-IsoWeekDate' -Tag ConvertFrom-IsoWeekDate -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Returns a DateTime object from an ISO week date string.' `
		-Tag ConvertFromIsoWeekDate,Convert,ConvertFrom,IsoWeekDate {
		It "ISO week date string '<InputObject>' should return DateTime value '<Result>'" -TestCases @(
			0..3000 |ForEach-Object {$date = (Get-Date 2000-01-01).AddDays($_); @{
				InputObject = Format-Date.ps1 -Format Iso8601WeekDate -Date $date
				Result = $date
			}}
		) {
			Param([string]$InputObject,[datetime]$Result)
			ConvertFrom-IsoWeekDate.ps1 $InputObject |Should -Be $Result
		}
	}
}
