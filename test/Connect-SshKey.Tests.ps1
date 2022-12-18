<#
.SYNOPSIS
Tests using OpenSSH to generate a key and connect it to an ssh server.
#>

Describe 'Connect-SshKey' -Tag Connect-SshKey {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir Connect-SshKey.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	BeforeEach {
		Mock ssh-keygen {
			Write-Information 'ssh-keygen called' -infa Continue
			mkdir $env:USERPROFILE\.ssh -ErrorAction Ignore
			"$(New-Guid)" |Out-File $env:USERPROFILE\.ssh\id_rsa.pub ascii
			"$(New-Guid)" |Out-File $env:USERPROFILE\.ssh\id_rsa._x_ ascii
		}
		Mock ssh {Write-Information "ssh $args" -infa Continue}
	}
	AfterEach {
		if(Test-Path $env:USERPROFILE\.ssh\id_rsa._x_)
		{
			Remove-Item $env:USERPROFILE\.ssh\id_rsa.*
		}
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
	Context 'Uses OpenSSH to generate a key and connect it to an ssh server' -Tag SshKey {
		It 'Sets up SSH key on server using ssh' {
			Connect-SshKey.ps1 crowpi -UserName pi
			Assert-MockCalled -CommandName ssh -ParameterFilter {
				$args.Count -eq 2 -and $args[0] -eq 'pi@crowpi' -and $args[1] -eq 'cat >> .ssh/authorized_keys'
			}
		}
	}
}
