<#
.SYNOPSIS
Tests Adds various configuration files and exported settings to a ZIP file.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Backup-Workstation' -Tag Backup-Workstation -Skip:$skip {
	BeforeAll {
		if(!(Get-Module -List PSSQLite)) {Install-Module PSSQLite -Force}
		if(!(Get-Module -List Microsoft.PowerShell.SecretManagement)) {Install-Module Microsoft.PowerShell.SecretManagement -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	# skipping because this test is extremely slow, but passed last time it ran
	Context 'Adds various configuration files and exported settings to a ZIP file.' `
		-Skip `
		-Tag BackupWorkstation,Backup,Workstation {
		It "Creates a ZIP file" {
			$file = 'TestDrive:\backup.zip'
			$file |Should -Not -Exist
			Backup-Workstation.ps1 $file
			$file |Should -Exist
			Expand-Archive $file -DestinationPath TestDrive:\
			'TestDrive:\env-vars.json' |Should -Exist
			<#
			https://github.com/brianary/scripts/actions/runs/4334380944/jobs/7568242489 :
			AppData
			backup.zip
			edge-keywords.json
			env-vars.json
			packages.json
			secret-vault.json
			AppData\Roaming
			AppData\Roaming\NuGet
			AppData\Roaming\NuGet\nuget.config
			#>
		}
	}
}
