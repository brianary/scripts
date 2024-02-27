<#
.SYNOPSIS
Tests exporting secret vault content.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Export-SecretVault' -Tag Export-SecretVault -Skip:$skip {
	BeforeAll {
		if(!(Get-Module -List Microsoft.PowerShell.SecretManagement)) {Install-Module Microsoft.PowerShell.SecretManagement -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Exports secret vault content' -Tag ExportSecretVault,Export,SecretVault {
		It "Returns the contents of the default vault" {
			Mock Get-SecretInfo {
				$values = New-Object 'Collections.Generic.Dictionary[string,object]'
				[pscustomobject]@{
					Name     = 'MockCredentials'
					Type     = 'PSCredential'
					Vault    = 'MockVault'
					Metadata = New-Object 'Collections.ObjectModel.ReadOnlyDictionary[string,object]' $values
				}
				$values.Add('Url','https://example.net/')
				$values.Add('Usage','Authorization: Bearer <token>')
				$values.Add('Description','API token A1')
				$values.Add('Expires','2024-08-16')
				[pscustomobject]@{
					Name     = 'MockToken'
					Type     = 'String'
					Vault    = 'MockVault'
					Metadata = New-Object 'Collections.ObjectModel.ReadOnlyDictionary[string,object]' $values
				}
			}
			Mock Get-Secret {
				switch($Name)
				{
					MockCredentials {[pscustomobject]@{UserName='mockuser';Password='123456' |ConvertTo-SecureString -AsPlainText -Force}}
					MockToken {'token_1234'}
				}
			}
			#Export-SecretVault.ps1 -Confirm:$false |ConvertTo-Json -Depth 100 |Write-Information -infa Continue
			Export-SecretVault.ps1 -Confirm:$false |ConvertTo-Json -Depth 100 |Should -BeExactly @"
[
  {
    "Name": "MockCredentials",
    "Type": "PSCredential",
    "Value": {
      "UserName": "mockuser",
      "Password": "123456"
    },
    "Vault": "",
    "Metadata": {
      "Url": "https://example.net/",
      "Usage": "Authorization: Bearer <token>",
      "Description": "API token A1",
      "Expires": "2024-08-16"
    }
  },
  {
    "Name": "MockToken",
    "Type": "String",
    "Value": "token_1234",
    "Vault": "",
    "Metadata": {
      "Url": "https://example.net/",
      "Usage": "Authorization: Bearer <token>",
      "Description": "API token A1",
      "Expires": "2024-08-16"
    }
  }
]
"@
		}
	}

}
