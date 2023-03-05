<#
.SYNOPSIS
Tests Adds various configuration files and exported settings to a ZIP file.
#>

Describe 'Backup-Workstation' -Tag Backup-Workstation {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		if(!(Get-Module -List PSSQLite)) {Install-Module PSSQLite -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Adds various configuration files and exported settings to a ZIP file.' `
		-Tag BackupWorkstation,Backup,Workstation {
		It "Creates a ZIP file" {
			$file = 'TestDrive:\backup.zip'
			$file |Should -Not -Exist
			Backup-Workstation.ps1 $file
			$file |Should -Exist
			Expand-Archive $file -DestinationPath TestDrive:\
			Get-ChildItem TestDrive:\ -Recurse
		}
	}
}
