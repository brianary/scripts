<#
.SYNOPSIS
Tests finding the most recent file.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Find-NewestFile' -Tag Find-NewestFile -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Finds the most recent file' -Tag FindNewestFile,Find,NewestFile {
		It "Gets most recent file" {
			0..4 |ForEach-Object {
				'test' |Out-File "TestDrive:/test$_.txt"
				(Get-Item "TestDrive:/test$_.txt").LastWriteTime =
					(Get-Item "TestDrive:/test$_.txt").LastWriteTime.AddMinutes(-$_)
			}
			Get-Item TestDrive:/test*.txt |Find-NewestFile.ps1 |Should -BeLike '*test0.txt'
		}
	}

}
