<#
.SYNOPSIS
Tests exporting the local list of Scheduled Tasks into a single XML file.
#>

Describe 'Backup-SchTasks' -Tag Backup-SchTasks {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir Backup-SchTasks.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
		Register-ScheduledTask -TaskName x -Description 'This is a test.' `
			-Action (New-ScheduledTaskAction -Execute pwsh -Argument 1) `
			-Trigger (New-ScheduledTaskTrigger -At 2022-02-22 -Once) |
			Write-Info.ps1 -fg DarkGray
		Push-Location TestDrive:\
	}
	AfterAll {
		try{Unregister-ScheduledTask -TaskName x -Confirm:$false -EA Stop}catch{Write-Warning "$_"}
		Pop-Location
	}
	Context 'Comment-based help' -Tag CommentHelp {
		It "Should produce help object" {
			Get-Help $ScriptName |Should -Not -BeOfType string `
				-Because 'Get-Help should not fall back to the default help string'
		}
	}
	Context 'Exports the local list of Scheduled Tasks into a single XML file' -Tag BackupSchTasks,Backup,SchTasks {
		It 'Should export to tasks.xml' {
			Backup-SchTasks.ps1
			'tasks.xml' |Should -Exist
			$taskxml = Select-Xml "/Tasks/t:Task[t:RegistrationInfo/t:URI='\x']" .\tasks.xml `
				-Namespace @{t='http://schemas.microsoft.com/windows/2004/02/mit/task'}
			$taskxml |Should -HaveCount 1
			$taskxml.Node.RegistrationInfo.Description |Should -BeExactly 'This is a test.'
			$taskxml.Node.RegistrationInfo.URI |Should -BeExactly '\x'
			$taskxml.Node.Actions.Exec.Command |Should -BeExactly 'pwsh'
			Remove-Item tasks.xml
		}
		It 'Should export to tasks-backup.xml using the tasks.css stylesheet' {
			Backup-SchTasks.ps1 tasks-backup.xml -Stylesheet tasks.css
			'tasks-backup.xml' |Should -Exist
			$taskxml = Select-Xml "/Tasks/t:Task[t:RegistrationInfo/t:URI='\x']" .\tasks-backup.xml `
				-Namespace @{t='http://schemas.microsoft.com/windows/2004/02/mit/task'}
			$taskxml |Should -HaveCount 1
			$taskxml.Node.RegistrationInfo.Description |Should -BeExactly 'This is a test.'
			$taskxml.Node.RegistrationInfo.URI |Should -BeExactly '\x'
			$taskxml.Node.Actions.Exec.Command |Should -BeExactly 'pwsh'
			$stylesheet = Select-Xml "/processing-instruction('xml-stylesheet')" .\tasks-backup.xml
			$stylesheet |Should -HaveCount 1
			$stylesheet.Node.OuterXml |Should -BeExactly '<?xml-stylesheet href="tasks.css" type="text/css"?>'
			Remove-Item tasks-backup.xml
		}
	}
}
