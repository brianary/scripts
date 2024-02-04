<#
.SYNOPSIS
Tests selecting named capture group values as note properties from Select-String MatchInfo objects.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Select-CapturesFromMatches' -Tag Select-CapturesFromMatches -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Selects named capture group values as note properties from Select-String MatchInfo objects' `
		-Tag SelectCapturesFromMatches,Select,Captures,Regex {
		It "Should select name '<Name>' and email '<Email>' from '<InputString>' using '<Regex>'" -TestCases @(
			@{ InputString = 'Arthur Dent adent@example.org'; Regex = '^(?<Name>.*?\b)\s*(?<Email>\S+@\S+)$'; Name = 'Arthur Dent'; Email = 'adent@example.org' }
			@{ InputString = 'Tricia McMillan <trillian@example.com>'; Regex = '^(?<Name>.*?\b)\s*<(?<Email>\S+@\S+)>$'; Name = 'Tricia McMillan'; Email = 'trillian@example.com' }
		) {
			Param([string] $InputString, [regex] $Regex, [string] $Name, [string] $Email)
			$captures = $InputString |Select-String $Regex |Select-CapturesFromMatches.ps1
			$captures.Name |Should -BeExactly $Name
			$captures.Email |Should -BeExactly $Email
		}
	}
}
