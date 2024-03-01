<#
.SYNOPSIS
Tests returning the differences between two dictionaries.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Compare-Keys' -Tag Compare-Keys -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
		$initialOutputRendering,$PSStyle.OutputRendering = $PSStyle.OutputRendering,'PlainText'
	}
	AfterAll {
		$PSStyle.OutputRendering = $initialOutputRendering
	}
	Context 'Returns the differences between two dictionaries' -Tag CompareKeys,Compare,Keys {
		$space = ' '
		It "Comparing '<ReferenceDictionary>' to '<DifferenceDictionary>' (including equal keys) should yield '<Result>'" -TestCases @(
			@{
				ReferenceDictionary = @{ A = 1; B = 2; C = 3 }
				DifferenceDictionary = @{ D = 6; C = 4; B = 2 }
				Result = @"
Key    Action ReferenceValue DifferenceValue
---    ------ -------------- ---------------
A     Deleted              1$space
B   Unchanged              2 2
C    Modified              3 4
D       Added                6
"@
			}
		) {
			Param([Collections.IDictionary]$ReferenceDictionary,[Collections.IDictionary]$DifferenceDictionary,[string]$Result)
			Compare-Keys.ps1 -ReferenceDictionary $ReferenceDictionary -DifferenceDictionary $DifferenceDictionary -IncludeEqual |
				Sort-Object Key |
				Out-String |
				ForEach-Object {$_.Trim()} |
				Should -BeExactly $Result
		}
	}
}
