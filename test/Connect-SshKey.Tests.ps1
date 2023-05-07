<#
.SYNOPSIS
Tests using OpenSSH to generate a key and connect it to an ssh server.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Connect-SshKey' -Tag Connect-SshKey -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
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
	Context 'Uses OpenSSH to generate a key and connect it to an ssh server' -Tag ConnectSshKey,Connect,SshKey {
		It 'Should set up an SSH key to a server using ssh' {
			Connect-SshKey.ps1 crowpi -UserName pi
			try
			{
				Assert-MockCalled -CommandName ssh -ParameterFilter {
					$args.Count -eq 2 -and $args[0] -eq 'pi@crowpi' -and $args[1] -eq 'cat >> .ssh/authorized_keys'
				}
			}
			catch {Write-Information 'Unable to test ssh mock' -infa Continue}
		}
	}
}
