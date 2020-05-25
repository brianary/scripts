<#
.Synopsis
	Gets the path of the VSCode settings.config file.

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
	Get-Command

.Link
	Stop-ThrowError.ps1

.Example
	Get-VSCodeSettingsFile.ps1

	C:\Users\zaphodb\AppData\Roaming\Code\User\settings.json

.Example
	Get-VSCodeSettingsFile.ps1 -Workspace

	C:\Users\zaphodb\GitHub\scripts\.vscode\settings.json
#>

[CmdletBinding()] Param(
[switch] $Workspace
)

${settings.json} =
	if($Workspace)
	{
		Use-Command.ps1 git "$env:ProgramFiles\Git\cmd\git.exe" -choco git
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
		# could also try Resolve-Path "$env:APPDATA\Code*\User\settings.json", but this is better targetted
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

${settings.json}
