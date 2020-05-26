<#
.Synopsis
	Sets a VSCode setting.

.Parameter Name
	The name of the setting to set, use / as a path separator for deeper structures.

.Parameter Workspace
	Indicates that the current workspace settings should be

.Link
	https://code.visualstudio.com/docs/getstarted/settings

.Link
	Get-VSCodeSettingsFile.ps1

.Link
	ConvertFrom-Json

.Link
	Get-Content

.Example
	Get-VSCodeSetting.ps1 gitlens.advanced.messages/suppressShowKeyBindingsNotice

	True

.Example
	Get-VSCodeSetting.ps1 powershell.codeFormatting.preset -Workspace

	Allman

.Example
	Get-VSCodeSetting.ps1 workbench.colorTheme -Workspace

	PowerShell ISE
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string] $Name,
[switch] $Workspace
)

$UnescapedPathSeparator = "(?<=(?:\A|[^\\])(?:\\\\)*)/"
$nameSegment,$path = ($Name -split $UnescapedPathSeparator) -replace '(?s)\\(.)','$1'
${settings.json} = Get-VSCodeSettingsFile.ps1 -Workspace:$Workspace
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
