<#
.SYNOPSIS
Tests exporting a portion of a JSON document, recursively importing references.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Export-Json' -Tag Export-Json -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Exports a portion of a JSON document, recursively importing references' `
		-Tag ExportJson,Export,Json {
		$NL = [Environment]::NewLine
		It "Given '<InputObject>', selecting '<JsonPointer>' with compressed set to '<Compress>' should return '<Result>'" -TestCases @(
			@{ InputObject = '{d:{a:{b:1,c:{"$ref":"#/d/two"}},two:2}}'
				JsonPointer = '/d/a'; Compress = $false; Result = "{$NL  `"b`": 1,$NL  `"c`": 2$NL}" }
			@{ InputObject = '{d:{a:{b:1,c:{"$ref":"#/d/c"}},c:{d:{"$ref":"#/d/two"}},two:2}}'
				JsonPointer = '/d/a'; Compress = $true; Result = '{"b":1,"c":{"d":2}}' }
		) {
			Param($InputObject, [string] $JsonPointer, [bool] $Compress, [string] $Result)
			$InputObject |Export-Json.ps1 -JsonPointer $JsonPointer -Compress:$Compress |
				Should -BeExactly $Result -Because 'pipeline should work'
			Export-Json.ps1 -JsonPointer $JsonPointer -Compress:$Compress -InputObject $InputObject |
				Should -BeExactly $Result -Because 'parameter should work'
		}
	}
}
