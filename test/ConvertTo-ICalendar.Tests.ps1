<#
.SYNOPSIS
Tests the script that transforms objects into iCalendar data.
#>

Describe 'Scheduled task conversion' {
	BeforeAll
	{
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'One-time' -Tag Once {
		It "A one-time trigger at '<DtStart>' should produce a matching DTSTART." -TestCases @(
			@{ DtStart = '2000-01-01T07:00' }
			@{ DtStart = '2002-02-20T22:11:33' }
			@{ DtStart = '2020-02-02T20:02' }
		) {
			Param([datetime]$DtStart)
			$result = Register-ScheduledTask -TaskName x -Description 'This is a test.' `
				-Action (New-ScheduledTaskAction -Execute pwsh -Argument 1) `
				-Trigger (New-ScheduledTaskTrigger -At $DtStart -Once) |
				ConvertTo-ICalendar.ps1
			Write-Host $result -fore Cyan
			$result -split '[\r\n]+' |
				Where-Object {$_ -like 'DTSTART[;:]*'} |
				Should -MatchExactly "\ADTSTART\b[^:]*:$([regex]::Escape((Get-Date $DtStart -Format yyyyMMdd\THHmmss)))\z"
		}
	}
	Context 'By minute' -Tag Minutely {
		It "A minutely trigger that runs every '<Interval>' should include recurrence '<Rule>'." -TestCases @(
			@{ Interval = 1; Rule = 'RRULE:FREQ=MINUTELY;INTERVAL=1' }
			@{ Interval = 2; Rule = 'RRULE:FREQ=MINUTELY;INTERVAL=2' }
			@{ Interval = 3; Rule = 'RRULE:FREQ=MINUTELY;INTERVAL=3' }
			@{ Interval = 5; Rule = 'RRULE:FREQ=MINUTELY;INTERVAL=5' }
		) {
			Param([int]$Interval,[string]$Rule)
			$start = (Get-Date).AddDays(100)
			schtasks /create /tn x /tr pwsh /sd (Get-Date $start -f d) /st (Get-Date $start -f HH:mm) `
				/sc minute /mo $Interval |Out-Null
			$result = Get-ScheduledTask -TaskName x |ConvertTo-ICalendar.ps1
			$result -split '[\r\n]+' |
				Where-Object {$_ -like 'RRULE:*'} |
				Should -BeExactly $Rule
		}
	}
	Context 'By hour' -Tag Hourly {
		It "An hourly trigger that runs every '<Interval>' should include recurrence '<Rule>'." -TestCases @(
			@{ Interval = 1; Rule = 'RRULE:FREQ=HOURLY;INTERVAL=1' }
			@{ Interval = 2; Rule = 'RRULE:FREQ=HOURLY;INTERVAL=2' }
			@{ Interval = 3; Rule = 'RRULE:FREQ=HOURLY;INTERVAL=3' }
			@{ Interval = 5; Rule = 'RRULE:FREQ=HOURLY;INTERVAL=5' }
		) {
			Param([int]$Interval,[string]$Rule)
			$start = (Get-Date).AddDays(100)
			schtasks /create /tn x /tr pwsh /sd (Get-Date $start -f d) /st (Get-Date $start -f HH:mm) `
				/sc hourly /mo $Interval |Out-Null
			$result = Get-ScheduledTask -TaskName x |ConvertTo-ICalendar.ps1
			$result -split '[\r\n]+' |
				Where-Object {$_ -like 'RRULE:*'} |
				Should -BeExactly $Rule
		}
	}
	Context 'By day' -Tag Daily {
		It "A daily trigger that runs every '<Interval>' should include recurrence '<Rule>'." -TestCases @(
			@{ Interval = 1; Rule = 'RRULE:FREQ=DAILY;INTERVAL=1' }
			@{ Interval = 2; Rule = 'RRULE:FREQ=DAILY;INTERVAL=2' }
			@{ Interval = 3; Rule = 'RRULE:FREQ=DAILY;INTERVAL=3' }
			@{ Interval = 5; Rule = 'RRULE:FREQ=DAILY;INTERVAL=5' }
		) {
			Param([int]$Interval,[string]$Rule)
			$start = (Get-Date).AddDays(100)
			$result = Register-ScheduledTask -TaskName x -Description 'This is a test.' `
				-Action (New-ScheduledTaskAction -Execute pwsh -Argument 1) `
				-Trigger (New-ScheduledTaskTrigger -At $start -Daily -DaysInterval $Interval) |
				ConvertTo-ICalendar.ps1 -Debug
			$result -split '[\r\n]+' |
				Where-Object {$_ -like 'RRULE:*'} |
				Should -BeExactly $Rule
		}
	}
	Context 'By week' -Tag Weekly {
		It "A weekly trigger that runs every '<Interval>' on days '<Days>' should include recurrence '<Rule>'." -TestCases @(
			@{ Interval = 1; Rule = 'RRULE:FREQ=WEEKLY;INTERVAL=1' }
			@{ Interval = 1; Days = 'Tuesday','Thursday'; Rule = 'RRULE:FREQ=WEEKLY;INTERVAL=1;BYDAY=TU,TH' }
			@{ Interval = 2; Rule = 'RRULE:FREQ=WEEKLY;INTERVAL=2' }
			@{ Interval = 2; Days = 'Saturday','Sunday'; Rule = 'RRULE:FREQ=WEEKLY;INTERVAL=2;BYDAY=SU,SA' }
			@{ Interval = 3; Rule = 'RRULE:FREQ=WEEKLY;INTERVAL=3' }
			@{ Interval = 3; Days = 'Monday','Tuesday','Wednesday','Thursday','Friday';
				Rule = 'RRULE:FREQ=WEEKLY;INTERVAL=3;BYDAY=MO,TU,WE,TH,FR' }
			@{ Interval = 5; Rule = 'RRULE:FREQ=WEEKLY;INTERVAL=5' }
			@{ Interval = 5; Days = 'Thursday'; Rule = 'RRULE:FREQ=WEEKLY;INTERVAL=5;BYDAY=TH' }
		) {
			Param([int]$Interval,[DayOfWeek[]]$Days = @(),[string]$Rule)
			$start = (Get-Date).AddDays(100)
			if($Days.Count -eq 0)
			{
				[DayOfWeek[]]$Days = 'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'
			}
			$daysParam = if($Days.Count -gt 0){@{DaysOfWeek=$Days}}else{@{}}
			$result = Register-ScheduledTask -TaskName x -Description 'This is a test.' `
				-Action (New-ScheduledTaskAction -Execute pwsh -Argument 1) `
				-Trigger (New-ScheduledTaskTrigger -At $start -Weekly -WeeksInterval $Interval @daysParam) |
				ConvertTo-ICalendar.ps1 -Debug
			$result -split '[\r\n]+' |
				Where-Object {$_ -like 'RRULE:*'} |
				Should -BeExactly $Rule
		}
	}
	Context 'By month' -Tag Monthly {
		It "A monthly trigger that runs '<Modifier>' '<Days>' '<Months>' should include recurrence '<Rule>'." -TestCases @(
			@{ Rule = 'RRULE:FREQ=MONTHLY' }
			@{ Modifier = 'second'; Days = 'mon'; Rule = 'RRULE:FREQ=MONTHLY' }
			@{ Modifier = 'last'; Days = 'thu'; Rule = 'RRULE:FREQ=MONTHLY' }
			@{ Modifier = 'lastday'; Months = 'feb'; Rule = 'RRULE:FREQ=MONTHLY' }
		) {
			Param([string]$Modifier,[string]$Days,[string]$Months,[string]$Rule)
			$start = (Get-Date).AddDays(100)
			$param = @()
			if($Modifier) {$param += @('/mo',$Modifier)}
			if($Days) {$param += @('/d',$Days)}
			if($Months) {$param += @('/m',$Months)}
			schtasks /create /tn x /tr pwsh /sd (Get-Date $start -f d) /st (Get-Date $start -f HH:mm) `
				/sc monthly @param |Out-Null
			$result = Get-ScheduledTask -TaskName x |ConvertTo-ICalendar.ps1 -Debug
			$result -split '[\r\n]+' |
				Where-Object {$_ -like 'RRULE:*'} |
				Should -BeExactly $Rule
		}
	}
	AfterEach {Unregister-ScheduledTask -TaskName x -Confirm:$false}
}
