<#
.Synopsis
	Sets a VSCode setting.

.Parameter Name
	The name of the setting to set, use / as a path separator for deeper structures.

.Parameter Value
	The value of the setting to set.

.Parameter Workspace
	Indicates that the current workspace settings should be set, rather than the user settings.

.Link
	https://code.visualstudio.com/docs/getstarted/settings

.Link
	Get-VSCodeSettingsFile.ps1

.Link
	Set-JsonProperty.ps1

.Example
	Set-VSCodeSetting.ps1 git.autofetch $true -Workspace

	Sets {"git.autofetch": true} in the VSCode user settings.

.Example
	Set-VSCodeSetting.ps1 powershell.codeFormatting.preset Allman -Workspace

	Sets {"powershell.codeFormatting.preset": "Allman"} in the VSCode workspace settings.

.Example
	Set-VSCodeSetting.ps1 workbench.colorTheme 'PowerShell ISE' -Workspace

	Sets {"workbench.colorTheme": "PowerShell ISE"} in the VSCode workspace settings.
#>

[CmdletBinding()][OutputType([void])] Param(
[Parameter(Position=0,Mandatory=$true)][string] $Name,
[Parameter(Position=1,Mandatory=$true)][AllowEmptyString()][AllowEmptyCollection()][AllowNull()]
[psobject] $Value,
[switch] $Workspace
)

${settings.json} = Get-VSCodeSettingsFile.ps1 -Workspace:$Workspace

if(!(${settings.json} |Split-Path |Test-Path -PathType Container)) {${settings.json} |Split-Path |mkdir |Out-Null}
if(!(Test-Path ${settings.json} -PathType Leaf)) {'{}' |Out-File ${settings.json} -Encoding utf8}

$settings = Get-Content ${settings.json} -Raw
$settings |Set-JsonProperty.ps1 $Name $Value -PathSeparator / -WarnOverwrite |Out-File ${settings.json} -Encoding utf8
