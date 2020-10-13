<#
.Synopsis
	Assigns a value to use for the specified cmdlet parameter to use when one is not specified.

.Parameter CommandName
	The name of a cmdlet, function, script, or alias to assign a default parameter value to.

.Parameter ParameterName
	The name or alias of the parameter to assign a default value to.

.Parameter Value
	The value to assign as a default.

.Parameter Scope
	The scope +1 of this default, 1=Local, 2=Parent, ..., Global=Global.

.Inputs
	System.Object containing the default value to assign.

.Link
	Stop-ThrowError.ps1

.Link
	Get-Command

.Link
	about_Scopes

.Example
	Set-ParameterDefault.ps1 epcsv nti $true -Scope Global

	Establishes that the -NoTypeInformation param of the Export-Csv cmdlet will be true if not otherwise specified,
	globally for the PowerShell session.

.Example
	Set-ParameterDefault.ps1 Select-Xml Namespace @{svg = 'http://www.w3.org/2000/svg'}

	Uses only the SVG namespace for Select-Xml when none are given explicitly.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][ValidateNotNullOrEmpty()][Alias('CmdletName')][string] $CommandName,
[Parameter(Position=1,Mandatory=$true)][ValidateNotNullOrEmpty()][string] $ParameterName,
[Parameter(Position=2,Mandatory=$true,ValueFromPipeline=$true)] $Value,
[string] $Scope = '1'
)
Begin
{
	$cmd = Get-Command $CommandName -ErrorAction SilentlyContinue
	if(!$cmd) {Stop-ThrowError.ps1 "Could not find command '$CommandName'" -Argument CommandName}
	if($cmd.CommandType -eq 'Alias') {$cmd = Get-Command $cmd.ResolvedCommandName}
	if($cmd.CommandType -notin 'Cmdlet','ExternalScript','Function','Script')
	{Stop-ThrowError.ps1 "Command '$CommandName' ($($cmd.CommandType)) not supported" -Argument CommandName}
	$name =
		try {"$($cmd.Name):$($cmd.ResolveParameter($ParameterName).Name)"}
		catch {Stop-ThrowError.ps1 "Could not find parameter '$ParameterName' for cmdlet '$CommandName'" -Argument ParameterName}
	$defaults = Get-Variable PSDefaultParameterValues -Scope $Scope -ErrorAction SilentlyContinue
}
Process
{
	Write-Verbose "Setting '$name' to '$Value'"
	if(!$defaults) {Set-Variable PSDefaultParameterValues @{$name=$Value} -Scope 1}
	else {$defaults.Value[$name] = $Value}
}
