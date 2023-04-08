<#
.SYNOPSIS
Tests exporting the local list of Scheduled Tasks into a single XML file.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Backup-SchTasks' -Tag Backup-SchTasks -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
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
