<#
.SYNOPSIS
Tests adding a VS Code MSSQL database connection to the repo.
#>

Describe 'Add-VsCodeDatabaseConnection' -Tag Add-VsCodeDatabaseConnection {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
		if(!(git config --global user.email)) {git config --global user.email "test@example.com"}
		if(!(git config --global user.name)) {git config --global user.name "Test User"}
	}
	BeforeEach {
		Push-Location (mkdir "TestDrive:\$(New-Guid)")
		git init |Write-Information -infa Continue
	}
	AfterEach {
		if("$PWD" -match "\A$([regex]::Escape($TestDrive))") {Pop-Location}
	}
	Context 'Script style' -Tag Style {
		It "Should follow best practices for style" {
			Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\Add-VsCodeDatabaseConnection.ps1" -Severity Warning |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly '' -Because 'there should be no style warnings'
			Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\Add-VsCodeDatabaseConnection.ps1" -Severity Error |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly '' -Because 'there should be no style errors'
		}
	}
	Context 'Adds a VS Code MSSQL database connection to the repo.' -Skip:(!!$psEditor) -Tag VsCodeDatabaseConnection {
		It 'Should add a trusted connection' -TestCases @(
			@{ ProfileName = 'ConnectionName'; ServerInstance = 'ServerName\instance'; Database = 'Database' }
			@{ ProfileName = 'AdventureWorks' ; ServerInstance = '(localdb)\ProjectsV13'; Database = 'AdventureWorks2016' }
		 ) {
			Param([string] $ProfileName, [string] $ServerInstance, [string] $Database)
			Add-VsCodeDatabaseConnection.ps1 -ProfileName $ProfileName `
				-ServerInstance $ServerInstance -Database $Database
			Join-Path .vscode settings.json |Should -Exist
			$conn = (Get-Content .vscode/settings.json |ConvertFrom-Json).'mssql.connections'
			$conn.authenticationType |Should -BeExactly Integrated
			$conn.profileName |Should -BeExactly $ProfileName
			$conn.server |Should -BeExactly $ServerInstance
			$conn.database |Should -BeExactly $Database
		}
	}
}
