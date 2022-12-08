<#
.SYNOPSIS
Tests creating a backup as a sibling to a file, with date and time values in the name.
#>

Describe 'Backup-File' -Tag Backup-File {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	BeforeEach {
		Push-Location TestDrive:\
	}
	AfterEach {
		Pop-Location
	}
	Context 'Script style' -Tag Style {
		It "Should follow best practices for style" {
			Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\Backup-File.ps1" -Severity Warning |
				Should -HaveCount 0 -Because 'there should be no style warnings'
			Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\Backup-File.ps1" -Severity Error |
				Should -HaveCount 0 -Because 'there should be no style errors'
		}
	}
	Context 'Simple backup' -Tag BackupFile {
		It 'Create a backup as a sibling to a file, with date and time values in the name' {
			"$(New-Guid)" |Out-File logfile.log
			Backup-File.ps1 logfile.log
			'logfile.log' |Should -Exist
			$null,$backup = Get-Item logfile*.log |Sort-Object CreationTime
			$backup |Should -HaveCount 1
			$backup.FullName |Should -Exist
			$backup.Name |Should -Match '\Alogfile-\d{14}\.log\z'
		}
	}
}
