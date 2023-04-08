<#
.SYNOPSIS
Tests serializing complex content into PowerShell literals.
#>

#Requires -Version 7
$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'ConvertTo-PowerShell' -Tag ConvertTo-PowerShell -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Serializes complex content into PowerShell literals.' -Tag ctps,ConvertToPowerShell,Convert,ConvertTo,PowerShell {
		It "Should convert '<Value>' into idiomatic numeric literal '<Result>'" -TestCases @(
			@{ Value = 0x0; Result = '0' }
			@{ Value = 0x1; Result = '1' }
			@{ Value = 0x7; Result = '7' }
			@{ Value = 0xFKB; Result = '15KB' }
			@{ Value = 9E0; Result = '9' }
			@{ Value = 1E0; Result = '1' }
			@{ Value = 4E0LGB; Result = '4LGB' }
			@{ Value = 1E0Y; Result = '1y' }
			@{ Value = 2E2UY; Result = '200uy' }
			@{ Value = 3E1SKB; Result = '30sKB' }
			@{ Value = 6E1USKB; Result = '60usKB' }
			@{ Value = 3E0UGB; Result = '3uGB' }
			@{ Value = 15E3ULPB; Result = '15000ulPB' }
		) {
			Param($Value, [string] $Result)
			$Value |ConvertTo-PowerShell.ps1 |Should -BeExactly $Result
		}
		It "Should convert JSON '<Value>' into PowerShell literals" -TestCases @(
			@{ Value = 'null'; Result = '$null' }
			@{ Value = '7'; Result = '7L' }
			@{ Value = '"Don''t Panic!"'; Result = "'Don''t Panic!'" }
			@{ Value = '"2000-01-01T00:00:00"'; Result = "[datetime]'2000-01-01T00:00:00'" }
			@{ Value = '[6,9,42]'; Result = "@(`r`n`t6L`r`n`t9L`r`n`t42L`r`n)" }
			@{ Value = '{}'; Result = "[pscustomobject]@{`r`n`r`n}" }
			@{ Value = '{"a":1,"b":2,"c":{"d":"2017-03-22T20:59:31","e":null}}'; Result = @'
[pscustomobject]@{
	a = 1L
	b = 2L
	c = [pscustomobject]@{
		d = [datetime]'2017-03-22T20:59:31'
		e = $null
	}
}
'@ }
		) {
			Param([string] $Value, [string] $Result)
			$expression = ConvertFrom-Json $Value -NoEnumerate |ConvertTo-PowerShell.ps1
			$expression |Should -BeExactly $Result
			Invoke-Expression $expression |ConvertTo-Json -Compress |Should -BeExactly $Value
		}
	}
	Context 'Serializes secure strings secured with a generated key' -Tag ctpsGenerateKey {
		It "Should generate PowerShell for secure '<Value>', using a generated zero key" -TestCases @(
			@{ Value = 'Test' }
			@{ Value = 'Lorem ipsum dolor' }
		) {
			Param([string] $Value)
			$expression = ConvertTo-SecureString $Value -AsPlainText -Force |
				ConvertTo-PowerShell.ps1 -GenerateKey |
				Out-String
			$expression |Should -BeLike '*ConvertTo-SecureString*'
			Invoke-Expression $expression |ConvertFrom-SecureString -AsPlainText |Should -BeExactly $Value
		}
	}
	Context 'Serialize secure strings secured with a provided password' -Tag ctpsSecureKey {
		It "Should generate PowerShell for secure '<Value>', using password '<Secret>'" -TestCases @(
			@{ Value = 'Test'; Secret = 'P@ssw0rd' }
			@{ Value = 'Lorem ipsum dolor'; Secret = '$w0rdf1sh' }
		) {
			Param([string] $Value, [string] $Secret)
			$secureKey = ConvertTo-SecureString $Secret -AsPlainText -Force
			$expression = ConvertTo-SecureString $Value -AsPlainText -Force |
				ConvertTo-PowerShell.ps1 -SecureKey $secureKey |
				Out-String
			$expression |Should -BeLike '*Rfc2898DeriveBytes*'
			$expression |Should -BeLike '*GetBytes*'
			$expression |Should -BeLike '*ConvertTo-SecureString*'
		}
	}
	Context 'Serialize secure strings secured with a credential' -Tag ctpsCredential {
		It "Should generate PowerShell for secure '<Value>', using credential '<Name>' : '<Secret>'" -TestCases @(
			@{ Value = 'Test'; Name = 'user'; Secret = 'P@ssw0rd!' }
			@{ Value = 'Lorem ipsum dolor'; Name = 'apikey'; Secret = '$w0rdF1sh' }
		) {
			Param([string] $Value, [string] $Name, [string] $Secret)
			$credential = New-Object pscredential $Name,(ConvertTo-SecureString $Secret -AsPlainText -Force)
			$expression = ConvertTo-SecureString $Value -AsPlainText -Force |
				ConvertTo-PowerShell.ps1 -Credential $credential |
				Out-String
			$expression |Should -BeLike '*ConvertTo-SecureString*'
		}
	}
	Context 'Serialize secure strings secured with a provided zero key' -Tag ctpsKeyBytes {
		It "Should generate PowerShell for secure '<Value>', using key bytes '<Secret>'" -TestCases @(
			@{ Value = 'Test'; Secret = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
			@{ Value = 'Lorem ipsum dolor'; Secret = 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
		) {
			Param([string] $Value, [byte[]] $Secret)
			$expression = ConvertTo-SecureString $Value -AsPlainText -Force |
				ConvertTo-PowerShell.ps1 -Key $Secret |
				Out-String
			$expression |Should -BeLike '*ConvertTo-SecureString*'
		}
	}
}
