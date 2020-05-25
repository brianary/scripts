<#
.Synopsis
	Sets a VSCode setting.

.Parameter Name
	The name of the setting to set, use / as a path separator for deeper structures.

.Parameter Value
	The value of the setting to set.

.Parameter Workspace
	Indicates that the current workspace settings should be

.Link
	https://code.visualstudio.com/docs/getstarted/settings

.Link
	https://powershell.github.io/PowerShellEditorServices/api/Microsoft.PowerShell.EditorServices.Extensions.EditorObject.html

.Link
	https://git-scm.com/docs/git-rev-parse

.Link
	Join-Path

.Link
	Set-JsonProperty.ps1

.Example
	Set-VSCodeSetting.ps1 powershell.codeFormatting.preset Allman -Workspace

	Sets {"powershell.codeFormatting.preset": "Allman"} for the VSCode workspace settings.
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string] $Name,
[Parameter(Position=1,Mandatory=$true)][AllowEmptyString()][AllowEmptyCollection()][AllowNull()]
[psobject] $Value,
[switch] $Workspace
)

${settings.json} =
	if($Workspace)
	{
		if($psEditor.GetType().FullName -eq 'Microsoft.PowerShell.EditorServices.Extensions.EditorObject')
		{
			Join-Path $psEditor.Workspace.Path .vscode/settings.json
		}
		elseif ((Get-Command git -ErrorAction SilentlyContinue) -and "$(git rev-parse --git-dir)")
		{
			Join-Path "$(git rev-parse --show-toplevel)" .vscode/settings.json
		}
		else
		{
			Write-Warning "Can't detect VSCode workspace or git repo. Assuming current directory."
			Join-Path "$PWD" .vscode/settings.json
		}
	}
	elseif($IsWindows -or $env:OS -eq 'Windows_NT')
	{
		"$env:APPDATA\Code - Insiders\User\settings.json","$env:APPDATA\Code\User\settings.json" |
			where {Test-Path $_ -PathType Leaf} |
			select -First 1
	}
	elseif($IsLinux)
	{
		"$HOME/.config/Code/User/settings.json"
	}
	elseif($IsMacOS)
	{
		"$HOME/Library/Application Support/Code/User/settings.json"
	}
	else
	{
		Stop-ThrowError.ps1 InvalidOperationException 'Unable to determine location of VSCode settings.json' `
			InvalidOperation $null OS
	}
Write-Verbose "Using VSCode settings ${settings.json}"

if(!(${settings.json} |Split-Path |Test-Path -PathType Container)) {${settings.json} |Split-Path |mkdir |Out-Null}
if(!(Test-Path ${settings.json} -PathType Leaf)) {'{}' |Out-File ${settings.json} -Encoding utf8}

$settings = Get-Content ${settings.json} -Raw |ConvertFrom-Json
$settings |Set-JsonProperty.ps1 $Name $Value -PathSeparator / |Out-File ${settings.json} -Encoding utf8
