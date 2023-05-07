<#
.SYNOPSIS
Sets a VSCode setting.

.FUNCTIONALITY
VSCode

.LINK
https://code.visualstudio.com/docs/getstarted/settings

.LINK
Get-VSCodeSettingsFile.ps1

.LINK
Set-JsonProperty.ps1

.EXAMPLE
Set-VSCodeSetting.ps1 git.autofetch $true -Workspace

Sets {"git.autofetch": true} in the VSCode user settings.

.EXAMPLE
Set-VSCodeSetting.ps1 powershell.codeFormatting.preset Allman -Workspace

Sets {"powershell.codeFormatting.preset": "Allman"} in the VSCode workspace settings.

.EXAMPLE
Set-VSCodeSetting.ps1 workbench.colorTheme 'PowerShell ISE' -Workspace

Sets {"workbench.colorTheme": "PowerShell ISE"} in the VSCode workspace settings.
#>

[CmdletBinding()][OutputType([void])] Param(
# The name of the setting to set, use / as a path separator for deeper structures.
[Parameter(Position=0,Mandatory=$true)][string] $Name,
# The value of the setting to set.
[Parameter(Position=1,Mandatory=$true)][AllowEmptyString()][AllowEmptyCollection()][AllowNull()]
[psobject] $Value,
# Indicates that the current workspace settings should be set, rather than the user settings.
[switch] $Workspace
)

${settings.json} = Get-VSCodeSettingsFile.ps1 -Workspace:$Workspace

if(!(${settings.json} |Split-Path |Test-Path -PathType Container)) {mkdir (${settings.json} |Split-Path) |Out-Null}
if(!(Test-Path ${settings.json} -PathType Leaf)) {'{}' |Out-File ${settings.json} -Encoding utf8}

$settings = Get-Content ${settings.json} -Raw
$settings |Set-JsonProperty.ps1 $Name $Value -PathSeparator / -WarnOverwrite |Out-File ${settings.json} -Encoding utf8

