<#
.SYNOPSIS
Tests parsing TSV clipboard data into HTML table data which is copied back to the clipboard.
#>

$sixspaces = ' '*6
$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Convert-ClipboardTsvToHtml' -Tag Convert-ClipboardTsvToHtml -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Parses TSV clipboard data into HTML table data which is copied back to the clipboard' `
		-Tag ConvertClipboardTsvToHtml,Convert,ClipboardTsv,Clipboard,Tsv,Html {
		It "Should convert '<TsvData>' to '<HtmlData>'" -TestCases @(
@{ TsvData = @"
Id`tName
1`tFirst
2`tSecond
3`tThird
"@ -split '\r?\n'; HtmlData = @"
Version:0.9$sixspaces
StartHTML:000000185$sixspaces
EndHTML:000000510$sixspaces
StartFragment:000000285$sixspaces
EndFragment:000000478$sixspaces
StartSelection:000000285$sixspaces
EndSelection:000000478
<!DOCTYPE HTML  PUBLIC "-//W3C//DTD HTML 4.0  Transitional//EN">
<html><body><!--StartFragment--><table>
<colgroup><col/><col/></colgroup>
<tr><th>Id</th><th>Name</th></tr>
<tr><td>1</td><td>First</td></tr>
<tr><td>2</td><td>Second</td></tr>
<tr><td>3</td><td>Third</td></tr>
</table><!--EndFragment--></body></html>
"@ }
@{ TsvData = @(
	[pscustomobject]@{ Name = 'New Year''s Day (observed)'; Date = '2023-01-02' }
	[pscustomobject]@{ Name = 'Martin Luther King, Jr Day'; Date = '2023-01-16' }
	[pscustomobject]@{ Name = 'Washington''s Birthday'; Date = '2023-02-20' }
) |ConvertTo-Csv -Delimiter "`t" -UseQuotes AsNeeded; HtmlData = @"
Version:0.9$sixspaces
StartHTML:000000185$sixspaces
EndHTML:000000603$sixspaces
StartFragment:000000285$sixspaces
EndFragment:000000571$sixspaces
StartSelection:000000285$sixspaces
EndSelection:000000571
<!DOCTYPE HTML  PUBLIC "-//W3C//DTD HTML 4.0  Transitional//EN">
<html><body><!--StartFragment--><table>
<colgroup><col/><col/></colgroup>
<tr><th>Name</th><th>Date</th></tr>
<tr><td>New Year&#39;s Day (observed)</td><td>2023-01-02</td></tr>
<tr><td>Martin Luther King, Jr Day</td><td>2023-01-16</td></tr>
<tr><td>Washington&#39;s Birthday</td><td>2023-02-20</td></tr>
</table><!--EndFragment--></body></html>
"@ }
		) {
			Param([string[]] $TsvData, [string] $HtmlData)
			Set-Clipboard -Value $TsvData
			Convert-ClipboardTsvToHtml.ps1
			$result = Invoke-WindowsPowerShell.ps1 {"$((Get-Clipboard -Format Text -TextFormatType Html) -join "`r`n")"}
			$result |Should -Be $HtmlData
		}
	}
}
