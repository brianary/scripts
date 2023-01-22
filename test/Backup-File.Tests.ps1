<#
.SYNOPSIS
Tests creating a backup as a sibling to a file, with date and time values in the name.
#>

Describe 'Backup-File' -Tag Backup-File {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir Backup-File.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	BeforeEach {
		Push-Location TestDrive:\
	}
	AfterEach {
		Pop-Location
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
	Context 'Simple backup' -Tag BackupFile,Backup,File {
		It 'Should create a backup as a sibling to a file, with date and time values in the name' {
			"$(New-Guid)" |Out-File logfile.log
			Backup-File.ps1 logfile.log
			'logfile.log' |Should -Exist
			$null,$backup = Get-Item logfile*.log |Sort-Object {$_.Name.Length}
			$backup |Should -HaveCount 1 -Because 'another file with a longer name should exist'
			$backup.FullName |Should -Exist -Because 'the file should exist'
			$backup.Name |Should -Match '\Alogfile-\d{14}\.log\z' -Because 'the backup file should include the date & time'
		}
	}
}
