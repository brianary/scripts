<#
.SYNOPSIS
Tests adding a VS Code MSSQL database connection to the repo.
#>

Describe 'Add-VsCodeDatabaseConnection' -Tag Add-VsCodeDatabaseConnection {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir Add-VsCodeDatabaseConnection.ps1
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
	Context 'Comment-based help' -Tag CommentHelp {
		It "Should produce help object" {
			Get-Help $ScriptName |Should -Not -BeOfType string `
				-Because 'Get-Help should not fall back to the default help string'
		}
	}
	Context 'Adds a VS Code MSSQL database connection to the repo.' `
		-Skip:(!!(Get-Variable psEditor -EA Ignore)) `
		-Tag AddVsCodeDatabaseConnection,Add,VsCodeDatabaseConnection {
		It 'Should add a trusted connection' -TestCases @(
			@{ ProfileName = 'ConnectionName'; ServerInstance = 'ServerName\instance'; Database = 'Database' }
			@{ ProfileName = 'AdventureWorks' ; ServerInstance = '(localdb)\ProjectsV13'; Database = 'AdventureWorks2016' }
		 ) {
			Param([string] $ProfileName, [string] $ServerInstance, [string] $Database)
			Join-Path .vscode settings.json |Should -Not -Exist -Because 'no settings should exist yet'
			Add-VsCodeDatabaseConnection.ps1 -ProfileName $ProfileName `
				-ServerInstance $ServerInstance -Database $Database
			Join-Path .vscode settings.json |Should -Exist -Because 'VSCode settings should now exist'
			$conn = (Get-Content .vscode/settings.json |ConvertFrom-Json).'mssql.connections'
			$conn.authenticationType |Should -BeExactly Integrated `
				-Because 'without credentials, create a trusted/integrated connection'
			$conn.profileName |Should -BeExactly $ProfileName
			$conn.server |Should -BeExactly $ServerInstance
			$conn.database |Should -BeExactly $Database
		}
	}
}
