<#
.SYNOPSIS
Sets a VSCode setting.

.OUTPUTS
System.String, System.Double, System.Int32, System.Boolean depending on VS Code JSON value type.

.FUNCTIONALITY
VSCode

.LINK
https://code.visualstudio.com/docs/getstarted/settings

.LINK
Get-VSCodeSettingsFile.ps1

.LINK
ConvertFrom-Json

.LINK
Get-Content

.EXAMPLE
Get-VSCodeSetting.ps1 gitlens.advanced.messages/suppressShowKeyBindingsNotice

True

.EXAMPLE
Get-VSCodeSetting.ps1 powershell.codeFormatting.preset -Workspace

Allman

.EXAMPLE
Get-VSCodeSetting.ps1 workbench.colorTheme -Workspace

PowerShell ISE
#>

[CmdletBinding()][OutputType([string],[double],[int],[bool])] Param(
# The name of the setting to set, use / as a path separator for deeper structures.
[Parameter(Position=0,Mandatory=$true)][string] $Name,
# Indicates that the current workspace settings should be
[switch] $Workspace
)

${settings.json} = Get-VSCodeSettingsFile.ps1 -Workspace:$Workspace
if(!(Test-Path ${settings.json} -Type Leaf)) {return $null}
$UnescapedPathSeparator = "(?<=(?:\A|[^\\])(?:\\\\)*)/"
$nameSegment,$path = ($Name -split $UnescapedPathSeparator) -replace '(?s)\\(.)','$1'
$property = Get-Content ${settings.json} -Raw |ConvertFrom-Json
while($nameSegment)
{
	if(!$property.PSObject.Properties.Match($nameSegment,'NoteProperty').Count)
	{
		Write-Verbose "VSCode setting not found: $Name"
		return $null
	}
	$property = $property.$nameSegment
	$nameSegment,$path = $path
}
$property
