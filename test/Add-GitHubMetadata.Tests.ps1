<#
.SYNOPSIS
Tests Adds GitHub Linguist overrides to a repo's .gitattributes.
#>

Describe 'Add-GitHubMetadata' -Tag Add-GitHubMetadata {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	BeforeEach {
		mkdir TestDrive:\testrepo |Out-Null
		Push-Location TestDrive:\testrepo
		git init
	}
	AfterEach {
		Pop-Location
		Remove-Item TestDrive:\testrepo -Recurse -Force
	}
	Context 'Set CODEOWNERS' -Tag CODEOWNERS {
		It "Default CODEOWNERS" {
			'TestDrive:\testrepo\.editorconfig' |Should -Not -Exist -Because 'A new repo should not have an .editorconfig'
			'TestDrive:\testrepo\README.md' |Should -Not -Exist -Because 'A new repo should not have a readme'
			'TestDrive:\testrepo\.github\CODEOWNERS' |Should -Not -Exist -Because 'A new repo should not have a CODEOWNERS'
			Add-GitHubMetadata.ps1 -DefaultOwner arthurd@example.com
			'TestDrive:\testrepo\.editorconfig' |Should -Exist
			'TestDrive:\testrepo\.editorconfig' |Should -FileContentMatchMultilineExactly '# defaults\r?\n\[\*\]\r?\nindent_style'
			'TestDrive:\testrepo\README.md' |Should -Exist
			'TestDrive:\testrepo\README.md' |Should -FileContentMatchMultilineExactly '\Atestrepo\r?\n========\r?\n'
			'TestDrive:\testrepo\.github\CODEOWNERS' |Should -Exist
			'TestDrive:\testrepo\.github\CODEOWNERS' |Should -FileContentMatchExactly '\* arthurd@example.com'
		}
	}

}
