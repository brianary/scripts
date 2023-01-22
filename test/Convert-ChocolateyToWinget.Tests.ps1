<#
.SYNOPSIS
Tests Change from managing various packages with Chocolatey to WinGet.
#>

Describe 'Convert-ChocolateyToWinget' -Tag Convert-ChocolateyToWinget {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir Convert-ChocolateyToWinget.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Comment-based help' -Tag CommentHelp {
		It "Should produce help object" {
			Get-Help $ScriptName |Should -Not -BeOfType string `
				-Because 'Get-Help should not fall back to the default help string'
		}
	}
	Context 'Script style' -Tag Style {
		It "Should follow best practices for style" {
			Invoke-ScriptAnalyzer -Path $ScriptName -Severity Warning -ExcludeRule PSAvoidUsingCmdletAliases |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly $null -Because 'there should be no style warnings'
			Invoke-ScriptAnalyzer -Path $ScriptName -Severity Error |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly $null -Because 'there should be no style errors'
		}
	}
	Context 'Change from managing various packages with Chocolatey to WinGet' `
		-Tag ConvertChocolateyToWinget,Convert,Chocolatey,Winget `
		-Skip:(!(([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).`
			IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
		It 'Should convert chocolatey packages to winget' {
			Mock choco {
				if($args.Count -gt 1 -and $args[0] -eq 'list')
				{
					'Chocolatey v1.2.1'
					if($args[1] -in '7zip','gh','git','vscode') {$args[1]}
				}
			}
			if(!(Get-Command winget -EA Ignore)) {function winget {Write-Information 'winget (placeholder)' -infa Continue}}
			Mock winget {
				if($args.Count -gt 1 -and $args[0] -eq 'install' -and $args[1] -eq '-e' -and $args[2] -eq '--id')
				{
					'winget v1.4.3132-preview'
					if($args[3] -in '7zip.7zip','GitHub.cli','Git.Git','Microsoft.VisualStudioCode') {"Installing $($args[3])..."}
					else {throw "Can't install $($args[3])"}
				}
			}
			Convert-ChocolateyToWinget.ps1 -Confirm:$false
			Assert-MockCalled -CommandName winget -ParameterFilter {
				$args[0] -eq 'install' -and $args[1] -eq '-e' -and $args[2] -eq '--id' -and
				$args[3] -in '7zip.7zip','GitHub.cli','Git.Git','Microsoft.VisualStudioCode'
			} -Times 4
		}
	}
}
