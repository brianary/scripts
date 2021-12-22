<#
.Synopsis
	Exports web server settings, shares, ODBC DSNs, and installed MSAs as PowerShell scripts and data.

.Parameter Path
	The path of the script to create.

.Link
	https://chocolatey.org/

.Link
	Export-WebConfiguration.ps1

.Link
	Export-SmbShares.ps1

.Example
	Export-Server.ps1

	Exports server settings as PowerShell scripts and data, including any of:

	- An editable script specified by the Path parameter (Import-${env:ComputerName}.ps1 by default)
	- Import-${env:ComputerName}WebConfiguration.ps1 for IIS settings
	- Import-${env:ComputerName}SmbShares.ps1 for Windows file shares
	- hosts containing customized hosts file entries
	- ODBC.reg containing ODBC system DSNs
	- *.dsn, each an ODBC file DSN found in the default file DSN path ${env:CommonProgramFiles}\ODBC\Data Sources
	- InstalledApplications.txt containing a list of non-Microsoft applications in "Programs and Features"
	  (Add/Remove Programs in older Windows versions)
#>

##Requires -RunAsAdministrator # not supported in legacy PowerShell
[CmdletBinding()][OutputType([void])] Param(
[string] $Path = "Import-${env:ComputerName}.ps1"
)

function Test-Administrator
{
	([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).`
		IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Export-Header
{
	Write-Verbose "Creating export script $Path"
	Write-Progress "Exporting $env:ComputerName" "Creating script $Path" -Id 1 -percent 0
	@"
<#
.Synopsis
	Imports web server settings, shares, and installed MSAs exported from ${env:ComputerName}.
#>

#Requires -Version 3
#Requires -RunAsAdministrator
##Requires -Module ActiveDirectory # uncomment to convert MSAs
[CmdletBinding(SupportsShouldProcess=`$true,ConfirmImpact='High')] Param()

"@
}

function Export-WebConfiguration
{
	@"

function Import-WebConfiguration
{
	[CmdletBinding()] Param()
	Write-Verbose 'Importing web configuration.'
	if(Test-Path 'Import-${env:ComputerName}WebConfiguration.ps1' -PathType Leaf)
	{.\Import-${env:ComputerName}WebConfiguration.ps1}
	elseif(Test-Path "`$PSScriptRoot\Import-${env:ComputerName}WebConfiguration.ps1" -PathType Leaf)
	{& "`$PSScriptRoot\Import-${env:ComputerName}WebConfiguration.ps1"}
	else
	{Write-Warning 'Could not find Import-${env:ComputerName}WebConfiguration.ps1, skipping web configuration import.'}
}
"@
	if(!(Get-Module WebAdministration -ListAvailable)){Write-Warning "IIS not detected. Skipping."; return}
	Write-Verbose "Exporting web configuration to Import-${env:ComputerName}WebConfiguration.ps1"
	Write-Progress "Exporting $env:ComputerName" "Exporting Import-${env:ComputerName}WebConfiguration.ps1" -Id 1 -percent 1
	Export-WebConfiguration.ps1
}

function Export-SmbShares
{
	@"

function Import-SmbShares
{
	[CmdletBinding(SupportsShouldProcess=`$true)] Param()
	if(!`$PSCmdlet.ShouldProcess('SMB shares','create')) {return}
	Write-Verbose 'Importing SMB shares.'
	if(Test-Path '' -PathType Leaf)
	{.\Import-${env:ComputerName}SmbShares.ps1}
	elseif(Test-Path "`$PSScriptRoot\Import-${env:ComputerName}SmbShares.ps1" -PathType Leaf)
	{& "`$PSScriptRoot\Import-${env:ComputerName}SmbShares.ps1"}
	else
	{Write-Warning 'Could not find Import-${env:ComputerName}SmbShares.ps1, skipping shares import.'}
}
"@
	Write-Verbose "Exporting SMB shares to $Path"
	Write-Progress "Exporting $env:ComputerName" "Creating script Import-${env:ComputerName}SmbShares.ps1" -Id 1 -percent 50
	Export-SmbShares.ps1
}

function Export-Hosts
{
	@'

function Import-Hosts
{
	[CmdletBinding(SupportsShouldProcess=$true)] Param()
	if(!(Test-Path $PSScriptRoot\hosts -PathType Leaf)) {return}
	if(!$PSCmdlet.ShouldProcess('hosts file','replace')) {return}
	Write-Verbose 'Updating hosts file'
	Move-Item $env:SystemRoot\system32\drivers\etc\hosts $env:SystemRoot\system32\drivers\etc\hosts.$(Get-Date -f yyyyMMddHHmmss)
	Copy-Item $PSScriptRoot\hosts $env:SystemRoot\system32\drivers\etc\hosts
}
'@
	if(!(Get-Content $env:SystemRoot\system32\drivers\etc\hosts |Select-String '^\s*\d')){return}
	Write-Verbose "Copying hosts file to $PWD"
	Write-Progress "Exporting $env:ComputerName" "Exporting hosts file" -Id 1 -percent 52
	Copy-Item $env:SystemRoot\system32\drivers\etc\hosts "$PWD"
}

function Export-SystemDsns
{
	@'

function Import-SystemDsns
{
	[CmdletBinding(SupportsShouldProcess=$true)] Param()
	if(!(Test-Path $PSScriptRoot\ODBC.reg)) {return}
	if(!$PSCmdlet.ShouldProcess('ODBC system DSNs','import')) {return}
	Write-Verbose 'Import ODBC system DSNs'
	regedit $PSScriptRoot\ODBC.reg
}
'@
	if(!(Get-ChildItem HKLM:\SOFTWARE\ODBC\ODBC.INI\*)){return}
	Write-Verbose "Exporting ODBC system DSNs to $PWD\ODBC.reg"
	Write-Progress "Exporting $env:ComputerName" "Exporting ODBC.reg" -Id 1 -percent 53
	regedit /e "$PWD\ODBC.reg" "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBC.INI"
}

function Export-FileDsns
{
	@'

function Import-FileDsns
{
	[CmdletBinding(SupportsShouldProcess=$true)] Param()
	if(!(Get-Item $PSScriptRoot\*.dsn)) {return}
	if(!$PSCmdlet.ShouldProcess('ODBC DSN files','copy')) {return}
	Write-Verbose 'Copying ODBC DSN files'
	mkdir "$env:CommonProgramFiles\ODBC\Data Sources"
	Copy-Item $PSScriptRoot\*.dsn "$env:CommonProgramFiles\ODBC\Data Sources"
}
'@
	if(!(Test-Path "$env:CommonProgramFiles\ODBC\Data Sources\*.dsn" -PathType Leaf)){return}
	Write-Verbose "Copying ODBC DSN files (*.dsn) to $PWD"
	Write-Progress "Exporting $env:ComputerName" "Exporting file DSNs (*.dsn) to $PWD" -Id 1 -percent 55
	Copy-Item "$env:CommonProgramFiles\ODBC\Data Sources\*.dsn" "$PWD"
}

function Export-Msas
{
	@"

function Import-Msas
{
	[CmdletBinding(SupportsShouldProcess=`$true)] Param()
	if(!`$PSCmdlet.ShouldProcess('MSAs','rebind')) {return}
	Write-Verbose 'Rebinding managed service accounts.'
	Get-ADServiceAccount -Filter * |
		Where-Object HostComputers -contains "`$(Get-ADComputer '${env:ComputerName}' |ForEach-Object DistinguishedName)" |
		Install-ADServiceAccount
}
"@
	Write-Verbose "Created import/conversion for MSAs in $Path"
	Write-Progress "Exporting $env:ComputerName" "MSA conversion created" -Id 1 -percent 57
}

function Export-ChocolateyPackages
{
	Write-Verbose "Exporting list of installed Chocolatey packages to $Path"
	Write-Progress "Exporting $env:ComputerName" "Exporting Chocolatey packages to $Path" -Id 1 -percent 60
	$cinst =
		if(!(Get-Command clist -CommandType Application -ErrorAction SilentlyContinue)) {@()}
		else
		{
			clist -lr |
				Select-Object -Skip 1 |
				ForEach-Object {
					$pkg,$ver = $_ -split '\|',2
					"if(`$PSCmdlet.ShouldProcess('$($pkg -replace "'","''")','install')) {cinst $pkg -y} # $ver"
				}
		}
	@"

function Import-ChocolateyPackages
{
	[CmdletBinding(SupportsShouldProcess=`$true)] Param()
	if(!`$PSCmdlet.ShouldProcess('$($cinst.Count) chocolatey packages','install')) {return}
	$($cinst -join "$([environment]::NewLine)    ")
}
"@
}

function Export-WebPlatformInstallerPackages
{
	Write-Verbose "Exporting list of installed WebPI packages to $Path"
	Write-Progress "Exporting $env:ComputerName" "Exporting WebPI packages to $Path" -Id 1 -percent 70
	$webpicmd =
		if(!(Get-Command webpicmd -CommandType Application -ErrorAction SilentlyContinue)) {@()}
		else
		{
			$webpiout = webpicmd /list /listoption:installed |
				Where-Object {![string]::IsNullOrWhiteSpace($_)}
			for($i = 0; $i -lt $webpiout.Count; $i++)
			{ if($webpiout[$i].Trim() -eq '----------------------------------------') {break} }
			(++$i)..($webpiout.Count -1) |
				ForEach-Object {
					$id,$title = $webpiout[$_] -split '\s+',2
					"if(`$PSCmdlet.ShouldProcess('$($id -replace "'","''")','install')) {webpicmd /install /products:$id} # $title"
				}
		}
	@"

function Import-WebPlatformInstallerPackages
{
	[CmdletBinding(SupportsShouldProcess=`$true)] Param()
	if(!`$PSCmdlet.ShouldProcess('$($webpicmd.Count) web platform installer packages','install')) {return}
	$($webpicmd -join "$([environment]::NewLine)    ")
}
"@
}

function Export-InstalledApplications
{
	Write-Verbose "Exporting list of installed applications to InstalledApplications.txt"
	Write-Progress "Exporting $env:ComputerName" "Exporting InstalledApplications.txt" -Id 1 -percent 80
	Get-CimInstance Win32_Product -Filter "Vendor <> 'Microsoft Corporation'" |
		Sort-Object Caption |
		ForEach-Object {"$($_.Caption) ($($_.Version))"} |
		Out-File InstalledApplications.txt utf8
}

function Export-Footer
{
	Write-Verbose "Finishing export to $Path"
	Write-Progress "Exporting $env:ComputerName" "Finishing script $Path" -Id 1 -percent 99
	@"

Import-WebConfiguration
Import-SmbShares
Import-Hosts
Import-SystemDsns
Import-FileDsns
#Import-Msas # uncomment to convert MSAs
Import-ChocolateyPackages
#Import-WebPlatformInstallerPackages # uncomment to install all the WebPI modules from the old server
"@
	Write-Progress "Exporting $env:ComputerName" -Id 1 -Completed
}

function Export-Server
{
	if(!(Test-Administrator)) {throw 'This script must be run as administrator.'}
	Export-Header
	Export-WebConfiguration
	Export-SmbShares
	Export-Hosts
	Export-SystemDsns
	Export-FileDsns
	Export-Msas
	Export-ChocolateyPackages
	Export-WebPlatformInstallerPackages
	Export-Footer
	Export-InstalledApplications
}

Export-Server |Out-File "Import-${env:ComputerName}.ps1" utf8
