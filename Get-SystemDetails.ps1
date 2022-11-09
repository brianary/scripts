<#
.SYNOPSIS
Collects some useful system hardware and operating system details via CIM.

.OUTPUTS
System.Management.Automation.PSCustomObject with properties about the computer:

* Name: The computer name.
* Status: The reported computer status name.
* Manufacturer: The reported computer manufacturer name.
* Model: The reported computer model name.
* PrimaryOwnerName: The reported name of the owner of the computer, if available.
* Memory: The reported memory in the computer, and amount unused.
* OperatingSystem: The name and type of operating system used by the computer.
* Processors: CPU hardware details.
* Video: Video controller hardware name.
* Drives: Storage drives found on the computer.
* Shares: The file shares configured, if any.
* NetVersions: The versions of .NET on the system.

.LINK
https://en.wikipedia.org/wiki/List_of_Microsoft_Windows_versions

.LINK
https://vdc-repo.vmware.com/vmwb-repository/dcr-public/3d076a12-29a2-4d17-9269-cb8150b5a37f/8b5969e2-1a66-4425-af17-feff6d6f705d/doc/class_CIM_OperatingSystem.html

.LINK
Get-CimInstance

.EXAMPLE
Get-SystemDetails.ps1

Name             : DEEPTHOUGHT
Status           : OK
Manufacturer     : Microsoft Corporation
Model            : Surface Pro 4
PrimaryOwnerName :
Memory           : 3.93 GiB (25.68 % free)
OperatingSystem  : Microsoft Windows 10 Pro
OSVersion        : 10.0.14393
OSUpdate         : 1607
OSType           : WINNT
OSArchitecture   : 64-bit
Processors       : Intel(R) Core(TM) i5-6300U CPU @ 2.40GHz
Video            : NVIDIA GeForce GTX 670
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
	OperatingSystem = $os.Caption + ' ' + $os.CSDVersion
	OSVersion = $os.Version
	OSUpdate =
		if($os.OSType -eq 18 -and $os.Version -like '10.*')
		{
			switch($os.BuildNumber)
			{
				22621 {'22H2'}
				22000 {'22H1'}
				19044 {'21H2'}
				19043 {'21H1'}
				19042 {'20H2'}
				19041 {'2004'}
				18363 {'1909'}
				18362 {'1903'}
				17763 {'1809'}
				17134 {'1803'}
				16299 {'1709'}
				15063 {'1703'}
				14393 {'1607'}
				10586 {'1511'}
				10240 {'1507'}
			}
		}
	OSType =
		switch($os.OSType)
		{
			0  {'Unknown'}
			1  {$os.OtherTypeDescription}
			2  {'MACOS'}
			3  {'ATTUNIX'}
			4  {'DGUX'}
			5  {'DECNT'}
			6  {'Tru64 UNIX'}
			7  {'OpenVMS'}
			8  {'HPUX'}
			9  {'AIX'}
			10 {'MVS'}
			11 {'OS400'}
			12 {'OS/2'}
			13 {'JavaVM'}
			14 {'MSDOS'}
			15 {'WIN3x'}
			16 {'WIN95'}
			17 {'WIN98'}
			18 {'WINNT'}
			19 {'WINCE'}
			20 {'NCR3000'}
			21 {'NetWare'}
			22 {'OSF'}
			23 {'DC/OS'}
			24 {'Reliant UNIX'}
			25 {'SCO UnixWare'}
			26 {'SCO OpenServer'}
			27 {'Sequent'}
			28 {'IRIX'}
			29 {'Solaris'}
			30 {'SunOS'}
			31 {'U6000'}
			32 {'ASERIES'}
			33 {'HP NonStop OS'}
			34 {'HP NonStop OSS'}
			35 {'BS2000'}
			36 {'LINUX'}
			37 {'Lynx'}
			38 {'XENIX'}
			39 {'VM'}
			40 {'Interactive UNIX'}
			41 {'BSDUNIX'}
			42 {'FreeBSD'}
			43 {'NetBSD'}
			44 {'GNU Hurd'}
			45 {'OS9'}
			46 {'MACH Kernel'}
			47 {'Inferno'}
			48 {'QNX'}
			49 {'EPOC'}
			50 {'IxWorks'}
			51 {'VxWorks'}
			52 {'MiNT'}
			53 {'BeOS'}
			54 {'HP MPE'}
			55 {'NextStep'}
			56 {'PalmPilot'}
			57 {'Rhapsody'}
			58 {'Windows 2000'}
			59 {'Dedicated'}
			60 {'OS/390'}
			61 {'VSE'}
			62 {'TPF'}
			63 {'Windows (R) Me'}
			64 {'Caldera Open UNIX'}
			65 {'OpenBSD'}
			66 {'Not Applicable'}
			67 {'Windows XP'}
			68 {'z/OS'}
			69 {'Microsoft Windows Server 2003'}
			70 {'Microsoft Windows Server 2003 64-Bit'}
			71 {'Windows XP 64-Bit'}
			72 {'Windows XP Embedded'}
			73 {'Windows Vista'}
			74 {'Windows Vista 64-Bit'}
			75 {'Windows Embedded for Point of Service'}
			76 {'Microsoft Windows Server 2008'}
			77 {'Microsoft Windows Server 2008 64-Bit'}
		}
	OSArchitecture = $os.OSArchitecture
	Processors = (Get-CimInstance CIM_Processor |
		ForEach-Object Name |
		ForEach-Object {$_ -replace '\s{2,}',' '})
	Video = Get-CimInstance CIM_VideoController |ForEach-Object Name
	Drives = (Get-CimInstance CIM_StorageVolume |
		Where-Object {$_.DriveType -eq 3 -and $_.DriveLetter -and $_.Capacity} |
		Sort-Object DriveLetter |
		ForEach-Object {"$($_.DriveLetter) $(Format-ByteUnits $_.Capacity -si -dot 2) ($('{0:p}' -f ($_.FreeSpace/$_.Capacity)) free)"})
	Shares= (Get-CimInstance Win32_Share |
		Where-Object {$_.Type -eq 0} |
		ForEach-Object {"$($_.Name)=$($_.Path)"})
	NetVersions = Get-DotNetFrameworkVersions.ps1
}
