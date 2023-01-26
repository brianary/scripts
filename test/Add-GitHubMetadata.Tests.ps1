﻿<#
.SYNOPSIS
Tests Adds GitHub Linguist overrides to a repo's .gitattributes.
#>

Describe 'Add-GitHubMetadata' -Tag Add-GitHubMetadata {
	BeforeAll {
		if(!(Get-Module -List Detextive)) {Install-Module Detextive -Force}
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir Add-GitHubMetadata.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
		if(!(git config --global user.email)) {git config --global user.email "test@example.com"}
		if(!(git config --global user.name)) {git config --global user.name "Test User"}
	}
	BeforeEach {
		Push-Location (mkdir "TestDrive:\$(New-Guid)")
		git init |Write-Information -infa Continue
		'' |Out-File nothing
		git add -A
		git commit -m first |Write-Information -infa Continue
		git status |Write-Information -infa Continue
		git shortlog |Write-Information -infa Continue
	}
	AfterEach {
		if("$PWD" -match "\A$([regex]::Escape($TestDrive))") {Pop-Location}
	}
	Context 'Comment-based help' -Tag CommentHelp {
		It "Should produce help object" {
			Get-Help $ScriptName |Should -Not -BeOfType string `
				-Because 'Get-Help should not fall back to the default help string'
		}
	}
	Context 'Script style' -Tag Style {
		It "Should follow best practices for style" {
			Invoke-ScriptAnalyzer -Path $ScriptName -Severity Warning |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly $null -Because 'there should be no style warnings'
			Invoke-ScriptAnalyzer -Path $ScriptName -Severity Error |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly $null -Because 'there should be no style errors'
		}
	}
	Context 'Add basic GitHub metadata' `
		-Tag AddGitHubMetadata,Add,GitHubMetadata,GitHub,Metadata,Readme,EditorConfig,CodeOwners,Linguist {
		It "Should create README.md, .editorconfig, CODEOWNERS, and .gitattributes (Linguist)" {
			'.gitattributes' |Should -Not -Exist -Because 'a new repo should not have a .gitattributes'
			'.editorconfig' |Should -Not -Exist -Because 'a new repo should not have an .editorconfig'
			'.github\CODEOWNERS' |Should -Not -Exist -Because 'a new repo should not have a CODEOWNERS'
			'README.md' |Should -Not -Exist -Because 'a new repo should not have a readme'
			Add-GitHubMetadata.ps1 -DefaultOwner 'test@example.com' -NoWarnings
			'.gitattributes' |Should -Exist
			'.gitattributes' |Should -FileContentMatchExactly '\*\*/packages/\*\* linguist-vendored' `
				-Because 'default Linguist settings should be added'
			'.editorconfig' |Should -Exist
			'.editorconfig' |Should -FileContentMatchMultilineExactly '# defaults\r?\n\[\*\]\r?\nindent_style' `
				-Because 'default .editorconfig settings should be added'
			'.github\CODEOWNERS' |Should -Exist
			'.github\CODEOWNERS' |Should -FileContentMatchExactly '\* test@example.com'
			'README.md' |Should -Exist
			'README.md' |Should -FileContentMatchMultilineExactly '\A.+\r?\n=+\r?\n' `
				-Because 'the readme should include a CommonMark Setext header'
		}
	}
	Context 'Set Linguist rules' -Tag AddGitHubMetadata,Add,GitHubMetadata,GitHub,Metadata,Linguist {
		It "Should set Linguist rules in .gitattributes" -Tag Linguist {
			Add-GitHubMetadata.ps1 -VendorCode openapi/*.cs -DocumentationCode docs/* `
				-GeneratedCode *.svg -NoWarnings
			'.gitattributes' |Should -FileContentMatchExactly '^openapi/\*\.cs linguist-vendored$'
			'.gitattributes' |Should -FileContentMatchExactly '^docs/\* linguist-documentation$'
			'.gitattributes' |Should -FileContentMatchExactly '^\*\.svg linguist-generated=true$'
		}
	}
	Context 'Set .editorconfig rules' -Tag AddGitHubMetadata,Add,GitHubMetadata,GitHub,Metadata,EditorConfig {
		It "Should set .editorconfig rules" {
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
	Context 'Set CODEOWNERS' -Tag AddGitHubMetadata,Add,GitHubMetadata,GitHub,Metadata,CodeOwners {
		It "Should set specific CODEOWNERS by pattern" {
			Add-GitHubMetadata.ps1 -DefaultOwner zaphodb@example.com -Owners @{
				'sql/*'  = 'eddie@example.com','marvin@example.com'
				'docs/*' = 'fordp@example.com'
			} -NoWarnings
			'.github/CODEOWNERS' |Should -FileContentMatchExactly '^\* zaphodb@example\.com$'
			'.github/CODEOWNERS' |Should -FileContentMatchExactly '^sql/\* eddie@example\.com marvin@example\.com$'
			'.github/CODEOWNERS' |Should -FileContentMatchExactly '^docs/\* fordp@example\.com$'
		}
	}
	Context 'Set templates' -Tag AddGitHubMetadata,Add,GitHubMetadata,GitHub,Metadata,Template {
		It "Should set issue template" {
			'.github\ISSUE_TEMPLATE.md' |Should -Not -Exist -Because 'a new repo should not have a ISSUE_TEMPLATE.md'
			$content = 'Thanks for submitting an issue'
			Add-GitHubMetadata.ps1 -IssueTemplate $content -NoWarnings
			'.github\ISSUE_TEMPLATE.md' |Should -FileContentMatchMultilineExactly "\A$([regex]::Escape($content))\r?\Z"
		}
		It "Should set pull request template" {
			'.github\PULL_REQUEST_TEMPLATE.md' |Should -Not -Exist -Because 'a new repo should not have a PULL_REQUEST_TEMPLATE.md'
			$content = 'Thanks for submitting a pull request'
			Add-GitHubMetadata.ps1 -PullRequestTemplate $content -NoWarnings
			'.github\PULL_REQUEST_TEMPLATE.md' |Should -FileContentMatchMultilineExactly "\A$([regex]::Escape($content))\r?\Z"
		}
		It "Should set contributing guidelines" {`
			'.github\CONTRIBUTING.md' |Should -Not -Exist -Because 'a new repo should not have a CONTRIBUTING.md'
			$content,$file = 'Thanks for your interest in contributing, here are the guidelines for the project',
				[io.path]::GetTempFileName()
			$content |Out-File $file utf8BOM
			Add-GitHubMetadata.ps1 -ContributingFile $file -NoWarnings
			'.github\CONTRIBUTING.md' |Should -FileContentMatchMultilineExactly "\A$([regex]::Escape($content))\r?\Z"
		}
		It "Should set license" {
			'LICENSE.md' |Should -Not -Exist -Because 'a new repo should not have a LICENSE.md'
			$content,$file = 'Thanks for using this project, here are the terms of use',[io.path]::GetTempFileName()
			$content |Out-File $file utf8BOM
			Add-GitHubMetadata.ps1 -LicenseFile $file -NoWarnings
			'LICENSE.md' |Should -FileContentMatchMultilineExactly "\A$([regex]::Escape($content))\r?\Z"
		}
		It "Should set Prettier disable" {
			if(Get-Variable psEditor -EA Ignore) {throw "Unable to run within VSCode terminal"}
			'.vscode\settings.json' |Should -Not -Exist -Because 'a new repo should not have VSCode settings'
			Add-GitHubMetadata.ps1 -VSCodeDisablePrettierForMarkdown
			'.vscode\settings.json' |Should -Exist
			$settings = Get-Content '.vscode\settings.json' -Raw |
				ConvertFrom-Json
			$settings |Should -BeOfType pscustomobject
			$settings.'prettier.disableLanguages' |Should -Be @('markdown')
			$settings.'[markdown]' |Should -BeOfType pscustomobject
			$settings.'[markdown]'.'editor.defaultFormatter' |Should -BeExactly 'yzhang.markdown-all-in-one'
		}
	}
}
