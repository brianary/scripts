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
Get-VSCodeSetting.ps1 /editor.renderWhitespace

all

.EXAMPLE
Get-VSCodeSetting.ps1 /powershell.codeFormatting.preset -Workspace

Allman

.EXAMPLE
Get-VSCodeSetting.ps1 /prettier.disableLanguages -Workspace

markdown
#>

[CmdletBinding()][OutputType([string])][OutputType([double])]
[OutputType([int])][OutputType([bool])] Param(
<#
The full path name of the property to set, as a JSON Pointer, which separates each nested
element name with a /, and literal / is escaped as ~1, and literal ~ is escaped as ~0.
#>
[Parameter(Position=0,Mandatory=$true)][Alias('Name')][AllowEmptyString()][ValidatePattern('\A(?:|/(?:[^~]|~0|~1)*)\z')]
[string] $JsonPointer = '',
# Indicates that the current workspace settings should be
[switch] $Workspace
)

${settings.json} = Get-VSCodeSettingsFile.ps1 -Workspace:$Workspace
if(!(Test-Path ${settings.json} -Type Leaf)) {return $null}
return Select-Json.ps1 $JsonPointer -Path ${settings.json}
