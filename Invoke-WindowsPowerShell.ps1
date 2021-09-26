<#
.Synopsis
	Runs commands in Windows PowerShell (typically from PowerShell Core).

.Parameter CommandBlock
	A script block to run.

.Parameter BlockArgs
	Parameters to the script block.

.Parameter CommandText
	The text of the command to run.

.Link
	Use-Command.ps1

.Link
	ConvertTo-Base64.ps1

.Link
	Stop-ThrowError.ps1

.Example
	Invoke-WindowsPowerShell.ps1 '$PSVersionTable.PSEdition'

	Desktop

.Example
	Invoke-WindowsPowerShell.ps1 {Param($n); Get-WmiObject Win32_Process -Filter "Name like '$n'" |foreach ProcessName} power%

	PowerToys.exe
	PowerToys.Awake.exe
	PowerToys.FancyZones.exe
	PowerToys.KeyboardManagerEngine.exe
	PowerLauncher.exe
	powershell.exe
	powershell.exe
#>

#Requires -Version 5
[CmdletBinding()] Param(
[Parameter(ParameterSetName='CommandBlock',Position=0,Mandatory=$true)][scriptblock] $CommandBlock,
[Parameter(ParameterSetName='CommandBlock',Position=1,ValueFromRemainingArguments=$true)][psobject[]] $BlockArgs = @(),
[Parameter(ParameterSetName='CommandText',Position=0,Mandatory=$true)][string] $CommandText
)

if($PSVersionTable.PSEdition -eq 'Desktop')
{
	if($PSCmdlet.ParameterSetName -eq 'CommandText') {Invoke-Expression $CommandText}
	else {$CommandBlock.InvokeReturnAsIs($BlockArgs)}
	return
}

Use-Command.ps1 powershell "$env:SystemRoot\system32\windowspowershell\v1.0\powershell.exe" -Fail

if(!(Get-Variable WPSModulePath -Scope Global -ValueOnly -ErrorAction SilentlyContinue))
{
	$addmodules = @()
	if('C:\Windows\System32\WindowsPowerShell\v1.0\Modules\' -notin ($env:PSModulePath -split ';'))
	{ $addmodules += 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\' }
	if("C:\Users\$env:UserName\Documents\WindowsPowerShell\Modules\" -notin ($env:PSModulePath -split ';'))
	{ $addmodules += "C:\Users\$env:UserName\Documents\WindowsPowerShell\Modules\" }
	$Global:WPSModulePath = if($addmodules.Count) {"$($addmodules -join ';');$env:PSModulePath"} else {$env:PSModulePath}
}
$PSModulePath = $env:PSModulePath # save current module path
$env:PSModulePath = $Global:WPSModulePath # use Windows PowerShell module path
if($PSCmdlet.ParameterSetName -eq 'CommandText')
{
	& "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -NonInteractive `
		-EncodedCommand (ConvertTo-Base64.ps1 $CommandText -Encoding utf16)
}
else
{
	if($Host.Name -eq 'Visual Studio Code Host')
	{
		Stop-ThrowError.ps1 'ScriptBlocks not supported by VSCode prompt' -OperationContext $CommandBlock
	}
	& "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -NonInteractive `
		-Command $CommandBlock -args $BlockArgs
}
$env:PSModulePath = $PSModulePath # restore module path
