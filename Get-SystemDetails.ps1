<#
.Synopsis
	Collects some useful system hardware and operating system details via CIM.

.Parameter ComputerName
	The computer from which to get CIM details.

.Parameter All
	Get all of the available details, rather than just the most pertinent ones.

.Outputs
	System.Management.Automation.PSCustomObject with properties about the computer:

		* Name: The computer name.
		* Status: The reported computer status name.
		* Manufacturer: The reported computer manufacturer name.
		* Model: The reported computer model name.
		* PrimaryOwnerName: The reported name of the owner of the computer, if available.
		* Memory: The reported memory in the computer, and amount unused.
		* OperatingSystem: The name and type of operating system used by the computer.
		* Processors: CPU hardware detais.
		* Drives: Storage drives found on the computer.
		* Shares: The file shares configured, if any.
		* NetVersions: The versions of .NET on the system.

.Link
	Get-CimInstance

.Example
	Get-SystemDetails.ps1

	Name             : DEEPTHOUGHT
	Status           : OK
	Manufacturer     : Microsoft Corporation
	Model            : Surface Pro 4
	PrimaryOwnerName :
	Memory           : 3.93 GiB (25.68 % free)
	OperatingSystem  : Microsoft Windows 10 Pro64-bit  (10.0.14393)
	Processors       : Intel(R) Core(TM) i5-6300U CPU @ 2.40GHz
	Drives           : C: 118 GiB (31.47 % free)
	Shares           :
	NetVersions      : {v4.6.2+win10ann, v3.5, v2.0.50727, v3.0}
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Management.Automation.PSCustomObject])] Param()
$cs = Get-CimInstance CIM_ComputerSystem
$os = Get-CimInstance CIM_OperatingSystem
[pscustomobject]@{
	Name = $cs.Name
	Status = $cs.Status
	Manufacturer = $cs.Manufacturer
	Model = $cs.Model
	PrimaryOwnerName = $cs.PrimaryOwnerName
	Memory = (Format-ByteUnits $cs.TotalPhysicalMemory -si -dot 2) +
		" ($('{0:p}' -f (1KB*$os.FreePhysicalMemory/$cs.TotalPhysicalMemory)) free)"
	OperatingSystem = $os.Caption + $(try{ $os.OSArchitecture }catch{''}) + ' ' + $os.CSDVersion + ' (' + $os.Version + ')'
	Processors = (Get-CimInstance CIM_Processor |
		% Name |
		% {$_ -replace '\s{2,}',' '})
	Drives = (Get-CimInstance CIM_StorageVolume |
		? {$_.DriveType -eq 3 -and $_.DriveLetter -and $_.Capacity} |
		sort DriveLetter |
		% {"$($_.DriveLetter) $(Format-ByteUnits $_.Capacity -si -dot 2) ($('{0:p}' -f ($_.FreeSpace/$_.Capacity)) free)"})
	Shares= (Get-CimInstance Win32_Share |
		? {$_.Type -eq 0} |
		% {"$($_.Name)=$($_.Path)"})
	NetVersions = Get-DotNetFrameworkVersions.ps1
}
