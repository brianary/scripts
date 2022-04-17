<#
.SYNOPSIS
Uses CIM to check a physical drive for busyness, and waits until a threshhold is value is confirmed.

.PARAMETER DriveName
The CIM drive name to check. Use this to list the available drives:

(Get-CimInstance Win32_PerfFormattedData_PerfDisk_PhysicalDisk).Name

.PARAMETER Interval
The frequency to check the drive busyness, as a TimeSpan.

.PARAMETER Threshhold
The percentage busyness below which the drive must measure consecutively.

.PARAMETER Consecutive
The number of times in a row that the busyness must by measured below the threshhold.

.EXAMPLE
Wait-DriveNotBusy.ps1

Waits until the system drive activity falls below 20% twice over a minute.
#>
#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0)][string] $DriveName = '0 C:',
[Parameter(Position=1)][timespan] $Interval = '00:01:00',
[Parameter(Position=2)][int] $Threshhold = 20,
[Parameter(Position=3)][int] $Consectutive = 2
)

$met = 0
do
{
	$p = (Get-CimInstance Win32_PerfFormattedData_PerfDisk_PhysicalDisk `
		-Filter "Name = '$($DriveName -replace "'","''")'").PercentDiskTime
	Write-Verbose "$(Get-Date -f G) $DriveName disk time $p%"
	if($p -lt $Threshhold) {$met++} else {$met = 0}
	Start-Sleep -Milliseconds $Interval.TotalMilliseconds
}
while ($met -lt $Consectutive)
