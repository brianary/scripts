<#
.SYNOPSIS
Installs winget.

.NOTES
Adapted from https://github.com/microsoft/winget-cli/issues/3068#issuecomment-1763402494

.LINK
https://api.github.com/repos/microsoft/winget-cli/
#>

#Requires -Modules Appx
[CmdletBinding()] Param(
# Installs the early development version.
[switch] $Prerelease
)

function Resolve-Download
{
	[CmdletBinding()] Param(
	[Parameter(ParameterSetName='FileName',Mandatory=$true)][string] $FileName,
	[Parameter(ParameterSetName='Uri',Mandatory=$true)][uri] $Uri
	)
	switch($PSCmdlet.ParameterSetName)
	{
		FileName {return Join-Path "$(Resolve-Path (Join-Path ~ Downloads))" $FileName}
		Uri {return Join-Path "$(Resolve-Path (Join-Path ~ Downloads))" ($Uri.Segments[-1])}
		default {Stop-ThrowError.ps1 'Bad params' -OperationContext $PSBoundParameters}
	}
}

function Save-File
{
	[CmdletBinding()] Param(
	[Parameter(Mandatory=$true)][uri] $Uri,
	[Parameter(Mandatory=$true)][string] $Path,
	[Parameter(Mandatory=$true)][string] $Hash
	)
	if((Test-Path $Path -Type Leaf) -and (Get-FileHash $Path).Hash -eq $Hash)
	{
		Write-Info.ps1 "Already downloaded $Uri" -fg Gray
		return
	}
	Write-Info.ps1 "Downloading $Uri" -fg Cyan
	Invoke-WebRequest -Uri $Uri -OutFile $Path
	if((Get-FileHash $Path).Hash -ne $Hash)
	{
		Stop-ThrowError.ps1 "File hash doesn't match" -OperationContext $Path
	}
	Write-Info.ps1 "Saved to $Path" -fg Green
}

function Save-Files
{
	[CmdletBinding()] Param()
	if([Net.ServicePointManager]::SecurityProtocol -lt [Net.SecurityProtocolType]::Tls12)
	{
		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	}
	$assets =
		if($Prerelease) {(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases?per_page=1).assets}
		else {(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets}
	$wingetfile = 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
	$wingeturi = $assets |Where-Object name -eq $wingetfile |Select-Object -ExpandProperty browser_download_url
	$wingethash = $assets |
		Where-Object name -eq "$([io.path]::ChangeExtension($wingetfile, 'txt'))" |
		Select-Object -ExpandProperty browser_download_url |
		ForEach-Object {Invoke-RestMethod $_}
	$wingetfile = Resolve-Download -FileName $wingetfile
	Save-File -Uri $wingeturi -Path $wingetfile -Hash $wingethash
	$vclibsuri = 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'
	$vclibsfile = Resolve-Download -Uri $vclibsuri
	Save-File -Uri $vclibsuri -Path $vclibsfile `
		-Hash 9BFDE6CFCC530EF073AB4BC9C4817575F63BE1251DD75AAA58CB89299697A569
	$zipfile = Resolve-Download -FileName Microsoft.UI.Xaml.2.7.zip
	Save-File -Uri https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.0 -Path $zipfile `
		-Hash 422FD24B231E87A842C4DAEABC6A335112E0D35B86FAC91F5CE7CF327E36A591
	$xamlfile = Resolve-Download -FileName Microsoft.UI.Xaml.2.7\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx
	if(!(Test-Path $xamlfile -Type Leaf))
	{
		Expand-Archive -Path $zipfile -DestinationPath (Resolve-Download -FileName Microsoft.UI.Xaml.2.7) -Force
	}
	return @{Path=$wingetfile;DependencyPath=$vclibsfile,$xamlfile}
}

function Install-WingetPackage
{
	[CmdletBinding()] Param()
	$appx = Save-Files
	Add-AppxPackage @appx
}

Install-WingetPackage
