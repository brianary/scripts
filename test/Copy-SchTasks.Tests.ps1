<#
.SYNOPSIS
Tests copying scheduled jobs from another computer to this one, using a GUI list to choose jobs.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Copy-SchTasks' -Tag Copy-SchTasks -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Copy scheduled jobs from another computer to this one, using a GUI list to choose jobs' `
		-Tag CopySchTasks,Copy,SchTasks {
		It "Tasks are copied from one system to another" {
			${\Backup Windows Terminal Config} = $false
			${\Update Everything} = $false
			${\PowerToys\Autorun for zaphodb} = $false
			Mock Out-GridView {$_}
			Mock Get-Credential {return New-Object pscredential zaphodb,('________' |ConvertTo-SecureString -AsPlainText -Force)}
			Mock schtasks {
				Write-Information "Mock: schtasks $args" -infa Continue
				if("$args" -eq '/query /s SourceComputer /v /fo csv')
				{
					return @'
"HostName","TaskName","Next Run Time","Status","Logon Mode","Last Run Time","Last Result","Author","Task To Run","Start In","Comment","Scheduled Task State","Idle Time","Power Management","Run As User","Delete Task If Not Rescheduled","Stop Task If Runs X Hours and X Mins","Schedule","Schedule Type","Start Time","Start Date","End Date","Days","Months","Repeat: Every","Repeat: Until: Time","Repeat: Until: Duration","Repeat: Stop If Still Running"
"SOURCECOMPUTER","\Backup Windows Terminal Config","2023-03-31 18:00:00","Ready","Interactive only","1999-11-30 00:00:00","267011","SOURCECOMPUTER\zaphodb",""C:\Program Files\PowerShell\7\pwsh.exe" -File C:\scripts\Backup-File.ps1 settings.json","%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState","Make a backup of the Windows Terminal configuration file.","Enabled","Disabled","Stop On Battery Mode, No Start On Batteries","zaphodb","Disabled","72:00:00","Scheduling data is not available in this format.","Monthly","18:00:00","2023-03-07","N/A","32","Every month","Disabled","Disabled","Disabled","Disabled"
"SOURCECOMPUTER","\Update Everything","N/A","Ready","Interactive only","1999-11-30 00:00:00","267011","SOURCECOMPUTER\zaphodb",""C:\Program Files\PowerShell\7\pwsh.exe" -File Update-Everything.ps1","A:\Scripts","Installs updates.","Enabled","Disabled","Stop On Battery Mode, No Start On Batteries","zaphodb","Disabled","72:00:00","Scheduling data is not available in this format.","At logon time","N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A"
"HostName","TaskName","Next Run Time","Status","Logon Mode","Last Run Time","Last Result","Author","Task To Run","Start In","Comment","Scheduled Task State","Idle Time","Power Management","Run As User","Delete Task If Not Rescheduled","Stop Task If Runs X Hours and X Mins","Schedule","Schedule Type","Start Time","Start Date","End Date","Days","Months","Repeat: Every","Repeat: Until: Time","Repeat: Until: Duration","Repeat: Stop If Still Running"
"HostName","TaskName","Next Run Time","Status","Logon Mode","Last Run Time","Last Result","Author","Task To Run","Start In","Comment","Scheduled Task State","Idle Time","Power Management","Run As User","Delete Task If Not Rescheduled","Stop Task If Runs X Hours and X Mins","Schedule","Schedule Type","Start Time","Start Date","End Date","Days","Months","Repeat: Every","Repeat: Until: Time","Repeat: Until: Duration","Repeat: Stop If Still Running"
"SOURCECOMPUTER","\PowerToys\Autorun for zaphodb","N/A","Ready","Interactive only","1999-11-30 00:00:00","267011","SOURCECOMPUTER\zaphodb","C:\Program Files\PowerToys\PowerToys.exe ","N/A","N/A","Enabled","Disabled","","zaphodb","Disabled","Disabled","Scheduling data is not available in this format.","At logon time","N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A"
'@
				}
				elseif("$args" -eq '/query /s SourceComputer /tn \Backup Windows Terminal Config /xml ONE')
				{
					return @'
<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>2023-03-07T20:16:06.4878026</Date>
    <Author>SOURCECOMPUTER\zaphodb</Author>
    <Description>Make a backup of the Windows Terminal configuration file.</Description>
    <URI>\Backup Windows Terminal Config</URI>
  </RegistrationInfo>
  <Principals>
    <Principal id="Author">
      <UserId>S-1-5-21-3500962627-3947184843-3951475229-1001</UserId>
      <LogonType>InteractiveToken</LogonType>
    </Principal>
  </Principals>
  <Settings>
    <DisallowStartIfOnBatteries>true</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <UseUnifiedSchedulingEngine>true</UseUnifiedSchedulingEngine>
  </Settings>
  <Triggers>
    <CalendarTrigger>
      <StartBoundary>2023-03-07T18:00:00</StartBoundary>
      <ScheduleByMonth>
        <Months>
          <January />
          <February />
          <March />
          <April />
          <May />
          <June />
          <July />
          <August />
          <September />
          <October />
          <November />
          <December />
        </Months>
        <DaysOfMonth>
          <Day>Last</Day>
        </DaysOfMonth>
      </ScheduleByMonth>
    </CalendarTrigger>
  </Triggers>
  <Actions Context="Author">
    <Exec>
      <Command>"C:\Program Files\PowerShell\7\pwsh.exe"</Command>
      <Arguments>-File C:\scripts\Backup-File.ps1 settings.json</Arguments>
      <WorkingDirectory>%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState</WorkingDirectory>
    </Exec>
  </Actions>
</Task>
'@
				}
				elseif("$args" -eq '/query /s SourceComputer /tn \Update Everything /xml ONE')
				{
					return @'
<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>2023-03-07T19:55:42.7350652</Date>
    <Author>SOURCECOMPUTER\zaphodb</Author>
    <Description>Installs updates.</Description>
    <URI>\Update Everything</URI>
  </RegistrationInfo>
  <Principals>
    <Principal id="Author">
      <UserId>S-1-5-21-3500962627-3947184843-3951475229-1001</UserId>
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <DisallowStartIfOnBatteries>true</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <UseUnifiedSchedulingEngine>true</UseUnifiedSchedulingEngine>
  </Settings>
  <Triggers>
    <LogonTrigger>
      <UserId>SOURCECOMPUTER\zaphodb</UserId>
    </LogonTrigger>
  </Triggers>
  <Actions Context="Author">
    <Exec>
      <Command>"C:\Program Files\PowerShell\7\pwsh.exe"</Command>
      <Arguments>-File Update-Everything.ps1</Arguments>
      <WorkingDirectory>A:\Scripts</WorkingDirectory>
    </Exec>
  </Actions>
</Task>
'@
				}
				elseif("$args" -eq '/query /s SourceComputer /tn \PowerToys\Autorun for zaphodb /xml ONE')
				{
					return @'
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <SecurityDescriptor>D:(A;;FA;;;WD)</SecurityDescriptor>
    <Author>SOURCECOMPUTER\zaphodb</Author>
    <URI>\PowerToys\Autorun for zaphodb</URI>
  </RegistrationInfo>
  <Principals>
    <Principal id="Principal1">
      <UserId>S-1-5-21-3500962627-3947184843-3951475229-1001</UserId>
      <LogonType>InteractiveToken</LogonType>
    </Principal>
  </Principals>
  <Settings>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <ExecutionTimeLimit>PT0S</ExecutionTimeLimit>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <IdleSettings>
      <Duration>PT10M</Duration>
      <WaitTimeout>PT1H</WaitTimeout>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
  </Settings>
  <Triggers>
    <LogonTrigger id="Trigger1">
      <Delay>PT3S</Delay>
      <UserId>SOURCECOMPUTER\zaphodb</UserId>
    </LogonTrigger>
  </Triggers>
  <Actions Context="Principal1">
    <Exec>
      <Command>C:\Program Files\PowerToys\PowerToys.exe</Command>
    </Exec>
  </Actions>
</Task>
'@
				}
				elseif("$args" -like '/create /s DestinationComputerName /tn \Backup Windows Terminal Config /ru zaphodb /rp ________ /xml *')
				{
					'\Backup Windows Terminal Config' |Add-Content TestDrive:\created.txt
				}
				elseif("$args" -like '/create /s DestinationComputerName /tn \Update Everything /ru zaphodb /rp ________ /xml *')
				{
					'\Update Everything' |Add-Content TestDrive:\created.txt
				}
				elseif("$args" -like '/create /s DestinationComputerName /tn \PowerToys\Autorun for zaphodb /ru zaphodb /rp ________ /xml *')
				{
					'\PowerToys\Autorun for zaphodb' |Add-Content TestDrive:\created.txt
				}
				else
				{
					Write-Information "Unmatched params: schtasks $args" -infa Continue
				}
			}
			Copy-SchTasks.ps1 SourceComputer DestinationComputerName
			$created = Get-Content TestDrive:\created.txt
			$created |Should -Contain '\Backup Windows Terminal Config' -Because "The '\Backup Windows Terminal Config' task should have been copied"
			$created |Should -Contain '\Update Everything' -Because "The '\Update Everything' task should have been copied"
			$created |Should -Contain '\PowerToys\Autorun for zaphodb' -Because "The '\PowerToys\Autorun for zaphodb' task should have been copied"
		}
	}
}

