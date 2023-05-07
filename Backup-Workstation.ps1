<#
.SYNOPSIS
Adds various configuration files and exported settings to a ZIP file.

.LINK
Export-InstalledPackages.ps1

.LINK
Export-EdgeKeywords.ps1

.LINK
Export-SecretVault.ps1

.EXAMPLE
Backup-Workstation.ps1

Saves various config data to COMPUTERNAME-20230304T125000.zip.
#>

#Requires -Version 7
[CmdletBinding()] Param(
[Parameter(Position=0)][string] $Path =
	(Join-Path ~ ('{0}-{1:yyyyMMdd\THHmmss}.zip' -f $env:COMPUTERNAME,(Get-Date)))
)

filter Copy-ItemToBackup
{
	Param(
	[Parameter(Position=0)][string] $Destination,
	[Parameter(ValueFromPipeline=$true)][string] $Item
	)
	if(!(Test-Path $Item)) {Write-Verbose "'$Item' not found"; return}
	$path = "$(Resolve-Path $Item)"
	$relpath = $path.Replace((Join-Path $env:USERPROFILE ''),'')
	$subdir = Split-Path $relpath
	if(Test-Path $path -Type Leaf)
	{
		if($subdir) {mkdir (Join-Path $Destination $subdir) |Out-Null}
		Copy-Item -Path $path -Destination (Join-Path $Destination $relpath)
	}
	elseif(Test-Path $path -Type Container)
	{
		if($subdir) {mkdir (Join-Path $Destination $subdir) |Out-Null}
		Copy-Item -Path $path -Destination (Join-Path $Destination $relpath) -Container -Recurse
	}
}

function Copy-ContentToBackup
{
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseProcessBlockForPipelineCommand','',
	Justification='This script uses $input within an End block.')]
	Param(
	[Parameter(Position=0)][string] $Destination,
	[Parameter(Position=1)][string] $FileName,
	[Parameter(ValueFromPipeline=$true)][psobject] $Item
	)
	End {$input |ConvertTo-Json |Out-File (Join-Path $Destination $FileName) utf8}
}

function Backup-Workstation
{
	$dir = Join-Path "$env:Temp" "$(New-Guid)"
	New-Item $dir -ItemType Directory |Out-Null
	@(
		Join-Path ~ .ssh
		Join-Path ~ SeqCli.json
		Join-Path ~ .npmrc
		Join-Path $env:APPDATA 'GitHub CLI' config.yml
		Join-Path $env:APPDATA NuGet nuget.config
		Join-Path $env:LOCALAPPDATA Packages Microsoft.WindowsTerminal_* LocalState settings.json
	) |Copy-ItemToBackup $dir
	@{
		User    = [Environment]::GetEnvironmentVariables('User')
		Machine = [Environment]::GetEnvironmentVariables('Machine')
	} |Copy-ContentToBackup $dir env-vars.json
	if(Join-Path $env:LocalAppData Microsoft Edge 'User Data' Default |Test-Path -Type Container)
	{
		Export-EdgeKeywords.ps1 |Copy-ContentToBackup $dir edge-keywords.json
	}
	Export-SecretVault.ps1 -Confirm:$false |Copy-ContentToBackup $dir secret-vault.json
	Export-InstalledPackages.ps1 |Copy-ContentToBackup $dir packages.json
	Get-ChildItem $dir |Compress-Archive -DestinationPath $Path
	Remove-Item $dir -Recurse -Force
}

Backup-Workstation

