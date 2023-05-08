<#
.SYNOPSIS
Enable TLS versions in Outlook on Windows 7.

.LINK
https://support.microsoft.com/help/3140245/update-to-enable-tls-1-1-and-tls-1-2-as-a-default-secure-protocols-in

.LINK
https://blogs.technet.microsoft.com/schrimsher/2016/07/08/enabling-tls-1-1-and-1-2-in-outlook-on-windows-7/

.LINK
http://thelowercasew.com/script-to-disable-protocols-older-than-tls-1-2-and-turn-off-rdp

.LINK
Test-Variable.ps1

.LINK
Set-RegistryValue

.LINK
Set-ItemProperty

.EXAMPLE
Set-DefaultSecurityProtocols.ps1

Enables TLS 1.2 only by default.
#>

#Requires -Version 4
#Requires -RunAsAdministrator
[CmdletBinding(SupportsShouldProcess=$true)][OutputType([void])] Param(
# The Protocols to use. SSL versions are ignored, only TLS versions are used.
[Net.SecurityProtocolType] $Protocols = 'Tls12'
)

function Set-RegistryValue
{
	[CmdletBinding(SupportsShouldProcess=$true)] Param(
	[Parameter(Position=0,Mandatory=$true)][string] $Path,
	[Parameter(Position=1,Mandatory=$true)][string] $Name,
	[Parameter(Position=2,Mandatory=$true)] $Value,
	[Parameter(Position=3)][Microsoft.Win32.RegistryValueKind] $Type = 'DWord',
	[switch] $AlsoSet32Bit,
	[switch] $UpdateCurrentUser
	)
	if($PSCmdlet.ShouldProcess("$Path\$Name = $Value","set"))
	{
		Write-Verbose "$Path\$Name was $(Get-ItemPropertyValue $Path $Name)"
		Set-ItemProperty $Path $Name $Value -Type $Type
	}
	Write-Verbose "$Path\$Name = $(Get-ItemPropertyValue $Path $Name)"

	if($AlsoSet32Bit -and $Path -like '*:\SOFTWARE\*' -and $Path -notlike '*:\SOFTWARE\Wow6432Node\*')
	{
		$Path32 = $Path -replace '(:\\SOFTWARE)\\','$1\Wow6432Node\'
		Set-RegistryValue $Path32 $Name $Value $Type -UpdateCurrentUser:$UpdateCurrentUser
	}

	if($UpdateCurrentUser -and $Path -like 'HKLM:*')
	{
		$PathUser = $Path -replace '\AHKLM:','HKCU:'
		if(Get-ItemProperty $PathUser $Name -ErrorAction Ignore)
		{
			Set-RegistryValue $PathUser $Name $Value $Type
		}
	}
}

Write-Progress 'Preparing' 'Checking Windows version' -PercentComplete 0
if(!(Test-Variable.ps1 WindowsVersion))
{[version]$Global:WindowsVersion = (Get-CimInstance CIM_OperatingSystem).Version}
if($WindowsVersion -lt 6.1 -or $WindowsVersion -gt 6.3) {throw 'This fix is only for Windows 7-8.1'}
if($WindowsVersion -ge 6.1 -and $WindowsVersion -lt 6.2)
{
	Write-Progress 'Preparing' 'Checking if KB3140245 is installed' -PercentComplete 20
	if(!((Test-Variable.ps1 KB3140245) -or (Get-HotFix KB3140245)))
	{throw 'KB3140245 needs to be installed'}
	$Global:KB3140245 = $true
}

Write-Progress 'Preparing' 'Parsing flags' -PercentComplete 92
if($Protocols.HasFlag([Net.SecurityProtocolType]'Ssl3')) {Write-Warning "SSL3 will be ignored."}
${TLS 1.0} = $Protocols.HasFlag([Net.SecurityProtocolType]'Tls')
${TLS 1.1} = $Protocols.HasFlag([Net.SecurityProtocolType]'Tls11')
${TLS 1.2} = $Protocols.HasFlag([Net.SecurityProtocolType]'Tls12')
$DefaultSecureProtocols = 0
if(${TLS 1.0}) {$DefaultSecureProtocols = $DefaultSecureProtocols -bor 0x80}
if(${TLS 1.1}) {$DefaultSecureProtocols = $DefaultSecureProtocols -bor 0x200}
if(${TLS 1.2}) {$DefaultSecureProtocols = $DefaultSecureProtocols -bor 0x800}
Write-Progress 'Preparing' -Completed

@{
	Path  = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp'
	Name  = 'DefaultSecureProtocols'
	Value = $DefaultSecureProtocols
	AlsoSet32Bit = $true
	UpdateCurrentUser = $true
} |ForEach-Object {Set-RegistryValue @_}

# disable old protocols
foreach($protocol in @('Multi-Protocol Unified Hello','PCT 1.0','SSL 2.0','SSL 3.0'))
{
	'Client','Server' |
		ForEach-Object {@{
			Path  = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\$_"
			Name  = 'Enabled'
			Value = 0
		},@{
			Path  = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\$_"
			Name  = 'DisabledByDefault'
			Value = 1
		}} |ForEach-Object {Set-RegistryValue @_}
}

'TLS 1.0','TLS 1.1','TLS 1.2' |
	ForEach-Object {@{
		Path  = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$_\Client"
		Name  = 'DisabledByDefault'
		Value = [int](Get-Variable $_ -ValueOnly)
	}} |
	ForEach-Object {Set-RegistryValue @_}
