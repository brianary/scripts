<#
.SYNOPSIS
Change from managing various packages with Chocolatey to WinGet.
#>

#Requires -Version 3
#Requires -RunAsAdministrator
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)] Param(
# Fully uninstalls the Chocolatey package before installing the corresponding winget package,
# instead of simply removing the package from the Chocolatey package list.
[switch] $Force
)
Begin
{
$cunistparams = if($Force) {@()} else {@('-n','--skipautoinstaller')}
$packages = Data {ConvertFrom-StringData @'
7zip=7zip.7zip
audacity=Audacity.Audacity
authy-desktop=Twilio.Authy
autohotkey=Lexikos.AutoHotkey
cdburnerxp=Canneverbe.CDBurnerXP
dotnet-sdk=Microsoft.dotnet
dotnetfx=Microsoft.dotNetFramework
dropbox=Dropbox.Dropbox
etcher=Balena.Etcher
firefox=Mozilla.Firefox
# winget is unable to pin packages, so specific hardware is not supported
#geforce-experience=Nvidia.GeForceExperience
gh=GitHub.cli
git=Git.Git
github=GitHub.GitHubDesktop
gitkraken=Axosoft.GitKraken
google-chrome-x64=Google.Chrome
googlechrome=Google.Chrome
googledrive=Google.Drive
googleearth=Google.EarthPro
graphviz=Graphviz.Graphviz
handbrake=HandBrake.HandBrake
hdhomerun-view=Silicondust.HDHomeRunTECH
inkscape=Inkscape.Inkscape
libreoffice=TheDocumentFoundation.LibreOffice
microsoft-edge=Microsoft.Edge
microsoft-windows-terminal=Microsoft.WindowsTerminal
mp3tag=Mp3tag.Mp3tag
mremoteng=mRemoteNG.mRemoteNG
# winget is unable to pin packages, so versions that use incompatible OpenSSL versions would be installed
#nodejs=OpenJS.NodeJS
oh-my-posh=JanDeDobbeleer.OhMyPosh
onedrive=Microsoft.OneDrive
powershell-core=Microsoft.PowerShell
powertoys=Microsoft.PowerToys
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
	foreach($p in $packages.Keys |Sort-Object)
	{
		if(!(choco list $p -erl --idonly |Select-Object -skip 1))
		{Write-Verbose "Chocolatey package '$p' not found, skipping."; continue}
		if(!$PSCmdlet.ShouldProcess("Chocolatey package '$p' with WinGet package '$($packages.$p)'",'replace')) {continue}
		Write-Verbose "Uninstalling Chocolatey package '$p'"
		choco uninstall $p -y @cunistparams
		Write-Verbose "Installing WinGet package '$($packages.$p)'"
		winget install $packages.$p
	}
}
