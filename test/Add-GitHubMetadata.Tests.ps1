<#
.SYNOPSIS
Tests Adds GitHub Linguist overrides to a repo's .gitattributes.
#>

Describe 'Add-GitHubMetadata' -Tag Add-GitHubMetadata {
	BeforeAll {
		if(!(Get-Module -List Detextive)) {Install-Module Detextive -Force}
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
		if(!(git config --global user.email)) {git config --global user.email "test@example.com"}
		if(!(git config --global user.name)) {git config --global user.name "Test User"}
	}
	BeforeEach {
		Push-Location (mkdir "TestDrive:\$(New-Guid)")
		git init |ForEach-Object {Write-Output "::debug::$_"}
		'' |Out-File nothing
		git add -A
		git commit -m first |ForEach-Object {Write-Output "::debug::$_"}
		git status |ForEach-Object {Write-Output "::debug::$_"}
		git shortlog |ForEach-Object {Write-Output "::debug::$_"}
	}
	AfterEach {
		if("$PWD" -match "\A$([regex]::Escape($TestDrive))") {Pop-Location}
	}
	Context 'Script style' -Tag Style {
		It "Should follow best practices for style" {
			Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\Add-GitHubMetadata.ps1" -Severity Warning |
				Should -HaveCount 0 -Because 'there should be no style warnings'
			Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\Add-GitHubMetadata.ps1" -Severity Error |
				Should -HaveCount 0 -Because 'there should be no style errors'
		}
	}
	Context 'Add basic GitHub metadata' -Tag Metadata,Readme,EditorConfig,CodeOwners,Linguist {
		It "Creates README.md, .editorconfig, CODEOWNERS, and .gitattributes (Linguist)" {
			'.gitattributes' |Should -Not -Exist -Because 'a new repo should not have a .gitattributes'
			'.editorconfig' |Should -Not -Exist -Because 'a new repo should not have an .editorconfig'
			'.github\CODEOWNERS' |Should -Not -Exist -Because 'a new repo should not have a CODEOWNERS'
			'README.md' |Should -Not -Exist -Because 'a new repo should not have a readme'
			Add-GitHubMetadata.ps1 -DefaultOwner arthurd@example.com -NoWarnings
			'.gitattributes' |Should -Exist
			'.gitattributes' |Should -FileContentMatchExactly '\*\*/packages/\*\* linguist-vendored'
			'.editorconfig' |Should -Exist
			'.editorconfig' |Should -FileContentMatchMultilineExactly '# defaults\r?\n\[\*\]\r?\nindent_style'
			'.github\CODEOWNERS' |Should -Exist
			'.github\CODEOWNERS' |Should -FileContentMatchExactly '\* arthurd@example.com'
			'README.md' |Should -Exist
			'README.md' |Should -FileContentMatchMultilineExactly '\A.+\r?\n=+\r?\n'
		}
	}
	Context 'Set Linguist rules' -Tag Metadata,Linguist {
		It "Sets Linguist rules in .gitattributes" -Tag Linguist {
			Add-GitHubMetadata.ps1 -VendorCode openapi/*.cs -DocumentationCode docs/* `
				-GeneratedCode *.svg -NoWarnings
			'.gitattributes' |Should -FileContentMatchExactly '^openapi/\*\.cs linguist-vendored$'
			'.gitattributes' |Should -FileContentMatchExactly '^docs/\* linguist-documentation$'
			'.gitattributes' |Should -FileContentMatchExactly '^\*\.svg linguist-generated=true$'
		}
	}
	Context 'Set .editorconfig rules' -Tag Metadata,EditorConfig {
		It "Sets .editorconfig rules" {
			Add-GitHubMetadata.ps1 -DefaultUsesTabs -DefaultIndentSize 6 -DefaultLineEndings cr `
				-DefaultCharset latin1 -DefaultKeepTrailingSpace -DefaultNoFinalNewLine -NoWarnings
			'.editorconfig' |Should -FileContentMatchExactly '^indent_style\s*=\s*tab$'
			'.editorconfig' |Should -FileContentMatchExactly '^indent_size\s*=\s*6$'
			'.editorconfig' |Should -FileContentMatchExactly '^tab_width\s*=\s*6$'
			'.editorconfig' |Should -FileContentMatchExactly '^end_of_line\s*=\s*cr$'
			'.editorconfig' |Should -FileContentMatchExactly '^charset\s*=\s*latin1$'
			'.editorconfig' |Should -FileContentMatchExactly '^trim_trailing_whitespace\s*=\s*false$'
			'.editorconfig' |Should -FileContentMatchExactly '^insert_final_newline\s*=\s*false$'
		}
	}
	Context 'Set CODEOWNERS' -Tag Metadata,CodeOwners {
		It "Sets specific CODEOWNERS by pattern" {
			Add-GitHubMetadata.ps1 -DefaultOwner zaphodb@example.com -Owners @{
				'sql/*'  = 'eddie@example.com','marvin@example.com'
				'docs/*' = 'fordp@example.com'
			} -NoWarnings
			'.github/CODEOWNERS' |Should -FileContentMatchExactly '^\* zaphodb@example\.com$'
			'.github/CODEOWNERS' |Should -FileContentMatchExactly '^sql/\* eddie@example\.com marvin@example\.com$'
			'.github/CODEOWNERS' |Should -FileContentMatchExactly '^docs/\* fordp@example\.com$'
		}
	}
	Context 'Set templates' -Tag Metadata,Template {
		It "Set issue template" {
			'.github\ISSUE_TEMPLATE.md' |Should -Not -Exist -Because 'a new repo should not have a ISSUE_TEMPLATE.md'
			$content = 'Thanks for submitting an issue'
			Add-GitHubMetadata.ps1 -IssueTemplate $content -NoWarnings
			'.github\ISSUE_TEMPLATE.md' |Should -FileContentMatchMultilineExactly "\A$([regex]::Escape($content))\r?\Z"
		}
		It "Set pull request template" {
			'.github\PULL_REQUEST_TEMPLATE.md' |Should -Not -Exist -Because 'a new repo should not have a PULL_REQUEST_TEMPLATE.md'
			$content = 'Thanks for submitting a pull request'
			Add-GitHubMetadata.ps1 -PullRequestTemplate $content -NoWarnings
			'.github\PULL_REQUEST_TEMPLATE.md' |Should -FileContentMatchMultilineExactly "\A$([regex]::Escape($content))\r?\Z"
		}
		It "Set contributing guidelines" {`
			'.github\CONTRIBUTING.md' |Should -Not -Exist -Because 'a new repo should not have a CONTRIBUTING.md'
			$content,$file = 'Thanks for your interest in contributing, here are the guidelines for the project',
				[io.path]::GetTempFileName()
			$content |Out-File $file utf8BOM
			Add-GitHubMetadata.ps1 -ContributingFile $file -NoWarnings
			'.github\CONTRIBUTING.md' |Should -FileContentMatchMultilineExactly "\A$([regex]::Escape($content))\r?\Z"
		}
		It "Set license" {
			'LICENSE.md' |Should -Not -Exist -Because 'a new repo should not have a LICENSE.md'
			$content,$file = 'Thanks for using this project, here are the terms of use',[io.path]::GetTempFileName()
			$content |Out-File $file utf8BOM
			Add-GitHubMetadata.ps1 -LicenseFile $file -NoWarnings
			'LICENSE.md' |Should -FileContentMatchMultilineExactly "\A$([regex]::Escape($content))\r?\Z"
		}
	}
}
