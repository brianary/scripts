<#
.SYNOPSIS
Gets the path of the VSCode settings.config file.

.OUTPUTS
System.String containing the path of the settings.config file.

.FUNCTIONALITY
VSCode

.LINK
https://code.visualstudio.com/docs/getstarted/settings

.LINK
https://powershell.github.io/PowerShellEditorServices/api/Microsoft.PowerShell.EditorServices.Extensions.EditorObject.html

.LINK
https://git-scm.com/docs/git-rev-parse

.LINK
Join-Path

.LINK
Get-Command

.LINK
Stop-ThrowError.ps1

.EXAMPLE
Get-VSCodeSettingsFile.ps1

C:\Users\zaphodb\AppData\Roaming\Code\User\settings.json

.EXAMPLE
Get-VSCodeSettingsFile.ps1 -Workspace

C:\Users\zaphodb\GitHub\scripts\.vscode\settings.json
#>

[CmdletBinding()][OutputType([string])] Param(
# Indicates that the current workspace settings should be parsed instead of the user settings.
[switch] $Workspace
)

${settings.json} =
	if($Workspace)
	{
		Use-Command.ps1 git "$env:ProgramFiles\Git\cmd\git.exe" -choco git
		if(Get-Variable psEditor -Scope Global -ErrorAction Ignore)
		{
			Join-Path $psEditor.Workspace.Path .vscode/settings.json
		}
		elseif ((Get-Command git -ErrorAction Ignore) -and "$(git rev-parse --git-dir)")
		{
			Join-Path "$(git rev-parse --show-toplevel)" .vscode/settings.json
		}
		else
		{
			Write-Warning "Can't detect VSCode workspace or git repo. Assuming current directory."
			Join-Path "$PWD" .vscode/settings.json
		}
	}
	else
	{
		if(!(Test-Path variable:IsWindows))
		{
			Set-Variable IsWindows ($PSVersionTable.PSEdition -eq 'Desktop' -or  $env:OS -eq 'Windows_NT')
		}
		if($IsWindows)
		{
			# could also try Resolve-Path "$env:APPDATA\Code*\User\settings.json", but this is better targetted
			"$env:APPDATA\Code - Insiders\User\settings.json","$env:APPDATA\Code\User\settings.json" |
				Where-Object {Test-Path $_ -PathType Leaf} |
				Select-Object -First 1
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
			Stop-ThrowError.ps1 'Unable to determine location of VSCode settings.json' `
				-OperationContext "$([environment]::OSVersion)"
		}
	}
Write-Verbose "Using VSCode settings ${settings.json}"

${settings.json}

