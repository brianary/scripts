<#
.SYNOPSIS
Tests copying configured issue labels from one repo to another.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Copy-GitHubLabels' -Tag Copy-GitHubLabels -Skip:$skip {
	BeforeAll {
		if(!(Get-Module -List PowerShellForGitHub)) {Install-Module PowerShellForGitHub -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Copies configured issue labels from one repo to another' -Tag CopyGitHubLabels,Copy,GitHubLabels {
		It "Should add, update, and delete labels as needed by ReplaceAll mode" {
			Mock Get-GitHubLabel {
				$OwnerName |Should -BeExactly owner
				switch($RepositoryName)
				{
					SourceRepo {return @"
[{"name":"enhancement","color":"84b6eb","default":true,"description":"New functionality","LabelName":"enhancement"},
 {"name":"duplicate","color":"cccccc","default":true,"description":"An issue that has already been reported.","LabelName":"duplicate"}]
"@ |ConvertFrom-Json}
					DestRepo {return @"
[{"name":"duplicate","color":"999999","default":true,"description":null,"LabelName":"duplicate"},
 {"name":"bug","color":"fc2929","default":true,"description":null,"LabelName":"bug"}]
"@ |ConvertFrom-Json}
					default {throw "Unknown repository: $RepositoryName"}
				}
			}
			Mock New-GitHubLabel {}
			Mock Set-GitHubLabel {}
			Mock Remove-GitHubLabel {}
			Copy-GitHubLabels.ps1 -OwnerName owner -RepositoryName SourceRepo -DestinationRepositoryName DestRepo -Mode ReplaceAll
			Assert-MockCalled -CommandName New-GitHubLabel -Times 1 -ParameterFilter {
				$OwnerName -eq 'owner' -and
				$RepositoryName -eq 'DestRepo' -and
				$Label -eq 'enhancement' -and
				$Color -eq '84b6eb' -and
				$Description -eq 'New functionality'
			}
			Assert-MockCalled -CommandName Set-GitHubLabel -Times 1 -ParameterFilter {
				$OwnerName -eq 'owner' -and
				$RepositoryName -eq 'DestRepo' -and
				$Label -eq 'duplicate' -and
				$Color -eq 'cccccc' -and
				$Description -eq 'An issue that has already been reported.'
			}
			Assert-MockCalled -CommandName Remove-GitHubLabel -Times 1 -ParameterFilter {
				$OwnerName -eq 'owner' -and
				$RepositoryName -eq 'DestRepo' -and
				$Label -eq 'bug'
			}
		}
	}
}

