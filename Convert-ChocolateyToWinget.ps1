<#
.SYNOPSIS
Change from managing various packages with Chocolatey to WinGet.

.EXAMPLE
Convert-ChocolateyToWinget.ps1 -SkipPackages autohotkey,git

Moves package management from Chocolatey to WinGet for everything except
autohotkey (maybey you are managing Adobe Digital Editions with Chocolatey),
or git (maybe you are managing PoshGit with Chocolatey).

.FUNCTIONALITY
Chocolatey
#>

#Requires -Version 3
#Requires -RunAsAdministrator
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)] Param(
# A specific package to convert
[Parameter(Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ValueFromRemainingArguments=$true)]
[string[]] $PackageName,
# Chocolatey packages to skip.
[string[]] $SkipPackages,
# Fully uninstalls the Chocolatey package before installing the corresponding winget package,
# instead of simply removing the package from the Chocolatey package list.
[switch] $Force
)
Begin
{
$cunistparams = if($Force) {@()} else {@('-n','--skipautouninstaller')}
$packages = Data {ConvertFrom-StringData @'
7zip=7zip.7zip
ag=JFLarvoire.Ag
audacity=Audacity.Audacity
authy-desktop=Twilio.Authy
autohotkey=Lexikos.AutoHotkey
azure-cli=Microsoft.AzureCLI
azure-data-studio=Microsoft.AzureDataStudio
azure-functions-core-tools=Microsoft.AzureFunctionsCoreTools
cdburnerxp=Canneverbe.CDBurnerXP
dellcommandupdate-uwp=Dell.CommandUpdate
dotnet-sdk=Microsoft.dotnet
dotnetfx=Microsoft.dotNetFramework
dropbox=Dropbox.Dropbox
emeditor=Emurasoft.EmEditor
etcher=Balena.Etcher
firefox=Mozilla.Firefox
# winget is unable to pin packages, so specific hardware is not supported
#geforce-experience=Nvidia.GeForceExperience
gh=GitHub.cli
git=Git.Git
github=GitHub.GitHubDesktop
github-desktop=GitHub.GitHubDesktop
gitkraken=Axosoft.GitKraken
google-chrome-x64=Google.Chrome
googlechrome=Google.Chrome
googledrive=Google.Drive
googleearth=Google.EarthPro
gotomeeting=LogMeIn.GoToMeeting
gource=acaudwell.Gource
graphviz=Graphviz.Graphviz
handbrake=HandBrake.HandBrake
hdhomerun-view=Silicondust.HDHomeRunTECH
inkscape=Inkscape.Inkscape
irfanview=IrfanSkiljan.IrfanView
libreoffice=TheDocumentFoundation.LibreOffice
microsoft-edge=Microsoft.Edge
microsoft-teams=Microsoft.Teams
# winget is unable to pin packages, so versions that use incompatible OpenSSL versions would be installed
#microsoft-windows-terminal=Microsoft.WindowsTerminal
mp3tag=Mp3tag.Mp3tag
mremoteng=mRemoteNG.mRemoteNG
# winget is unable to pin packages, so versions that use incompatible OpenSSL versions would be installed
#nodejs=OpenJS.NodeJS
NSwagStudio=RicoSuter.NSwagStudio
oh-my-posh=JanDeDobbeleer.OhMyPosh
onedrive=Microsoft.OneDrive
# winget isn't as scriptable as choco for updating the shell basics
#powershell-core=Microsoft.PowerShell
powertoys=Microsoft.PowerToys
python=Python.Python.3
python3=Python.Python.3
rpi-imager=RaspberryPiFoundation.RaspberryPiImager
slack=SlackTechnologies.Slack
steam=Valve.Steam
steam-client=Valve.Steam
sumatrapdf=SumatraPDF.SumatraPDF
sumatrapdf.install=SumatraPDF.SumatraPDF
ubisoft-connect=Ubisoft.Connect
# vcredist-all is a convenient metapackage, which winget doesn't really support
visualstudio2019buildtools=Microsoft.VisualStudio.2019.BuildTools
visualstudio2022buildtools=Microsoft.VisualStudio.2022.BuildTools
vlc=VideoLAN.VLC
vlc.install=VideoLAN.VLC
vscode=Microsoft.VisualStudioCode
vscode.install=Microsoft.VisualStudioCode
vscode-insiders=Microsoft.VisualStudioCode.Insiders
vscode-insiders.install=Microsoft.VisualStudioCode.Insiders
windirstat=WinDirStat.WinDirStat
winmerge=WinMerge.WinMerge
zoom=Zoom.Zoom
'@}
}
Process
{
	if(!$PackageName) {$PackageName = $packages.Keys |Sort-Object}
	foreach($p in $PackageName)
	{
		if($p -in $SkipPackages) {Write-Verbose "Skipping Chocolatey package '$p'"; continue}
		if(!$packages.ContainsKey($p)) {Write-Error "Chocolatey package '$p' has not been mapped to a WinGet package"; continue}
		if(!(choco list $p -erl --idonly |Select-Object -skip 1))
		{Write-Verbose "Chocolatey package '$p' not found, skipping."; continue}
		if(!$PSCmdlet.ShouldProcess("Chocolatey package '$p' with WinGet package '$($packages.$p)'",'replace')) {continue}
		Write-Verbose "Uninstalling Chocolatey package '$p'"
		choco uninstall $p -y @cunistparams
		Write-Verbose "Installing WinGet package '$($packages.$p)'"
		winget install $packages.$p
	}
}
