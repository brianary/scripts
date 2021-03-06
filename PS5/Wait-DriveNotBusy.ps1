<#
.Synopsis
	Uses WMI to check a physical drive for busyness, and waits until a threshhold is value is confirmed.

.Parameter DriveName
	The WMI drive name to check. Use this to list the available drives:

		(Get-WMIObject Win32_PerfFormattedData_PerfDisk_PhysicalDisk).Name

.Parameter Interval
	The frequency to check the drive busyness, as a TimeSpan.

.Parameter Threshhold
	The percentage busyness below which the drive must measure consecutively.

.Parameter Consecutive
	The number of times in a row that the busyness must by measured below the threshhold.

.Example
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
	$p = (Get-WMIObject Win32_PerfFormattedData_PerfDisk_PhysicalDisk `
		-Filter "Name = '$($DriveName -replace "'","''")'").PercentDiskTime
	Write-Verbose "$(Get-Date -f G) $DriveName disk time $p%"
	if($p -lt $Threshhold) {$met++} else {$met = 0}
	Start-Sleep -Milliseconds $Interval.TotalMilliseconds
}
while ($met -lt $Consectutive)
