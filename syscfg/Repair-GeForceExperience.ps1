<#
.Synopsis
	Fix "Something went wrong. Try restarting GeForce Experience."

.Description
	1. Disable Windows Update to prevent it from downloading the drivers automatically.
	2. Remove all Nvidia related files with DDU using this guide.
	3. Reinstall latest drivers with custom settings (clean installation, only drivers & PhysX are ticked).
	4. Install the latest GFE 3.

.Link
	https://forums.geforce.com/default/topic/970307/geforce-experience/-solved-something-went-wrong-try-restarting-gfe-/

.Link
	Use-Command.ps1
#>

#Requires -Version 3
#Requires -RunAsAdministrator
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')][OutputType([void])] Param(
[switch] $Finish
)

$scriptname= $MyInvocation.MyCommand.Name
if(!$Finish)
{
	Use-Command.ps1 bcdedit "$env:windir\system32\bcdedit.exe" -Fail
	if((Get-CimInstance CIM_ComputerSystem).BootupState -notlike 'Fail-safe *')
	{
		Write-Host "Reboot in Safe Mode before running $scriptname" -fore Magenta
		if($PSCmdlet.ShouldProcess($env:ComputerName,'reboot into safe mode'))
		{
			bcdedit --% /set {current} safeboot network
			Use-Command.ps1 shutdown "$env:windir\system32\shutdown.exe" -Fail
			shutdown --% /r
		}
		return
	}
	Stop-Service wuauserv
	Set-Service wuauserv -StartupType Disabled
	Use-Command.ps1 'Display Driver Uninstaller' "$env:ChocolateyInstall\bin\Display Driver Uninstaller.exe" -cinst ddu
	Write-Host "In Display Driver Uninstaller, run Clean and restart, then run $scriptname with -Finish" -fore Green
	Start-Process 'Display Driver Uninstaller.exe'
	# is the following needed?
	bcdedit --% /deletevalue {current} safeboot
}
else
{
	Use-Command.ps1 choco "$env:ChocolateyInstall\bin\choco.exe" -ExecutePowerShell https://chocolatey.org/install.ps1
	choco install nvidia-display-driver -y
	choco install geforce-experience -y
	Set-Service wuauserv -StartupType Manual
}
