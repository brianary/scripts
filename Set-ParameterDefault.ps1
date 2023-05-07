<#
.SYNOPSIS
Assigns a value to use for the specified cmdlet parameter to use when one is not specified.

.INPUTS
System.Object containing the default value to assign.

.FUNCTIONALITY
Parameters

.LINK
Add-ScopeLevel.ps1

.LINK
Stop-ThrowError.ps1

.LINK
Get-Command

.LINK
about_Scopes

.EXAMPLE
Set-ParameterDefault.ps1 epcsv nti $true -Scope Global

Establishes that the -NoTypeInformation param of the Export-Csv cmdlet will be true if not otherwise specified,
globally for the PowerShell session.

.EXAMPLE
Set-ParameterDefault.ps1 Select-Xml Namespace @{svg = 'http://www.w3.org/2000/svg'}

Uses only the SVG namespace for Select-Xml when none are given explicitly.
#>

#Requires -Version 3
[CmdletBinding()] Param(
# The name of a cmdlet, function, script, or alias to assign a default parameter value to.
[Parameter(Position=0,Mandatory=$true)][ValidateNotNullOrEmpty()][Alias('CmdletName')][string] $CommandName,
# The name or alias of the parameter to assign a default value to.
[Parameter(Position=1,Mandatory=$true)][ValidateNotNullOrEmpty()][string] $ParameterName,
# The value to assign as a default.
[Parameter(Position=2,Mandatory=$true,ValueFromPipeline=$true)] $Value,
# The scope of this default.
[string] $Scope = 'Local'
)
Begin
{
	$Scope = Add-ScopeLevel.ps1 $Scope
	$cmd = Get-Command $CommandName -ErrorAction Ignore
	if(!$cmd) {Stop-ThrowError.ps1 "Could not find command '$CommandName'" -Argument CommandName}
	if($cmd.CommandType -eq 'Alias') {$cmd = Get-Command $cmd.ResolvedCommandName}
	if($cmd.CommandType -notin 'Cmdlet','ExternalScript','Function','Script')
	{Stop-ThrowError.ps1 "Command '$CommandName' ($($cmd.CommandType)) not supported" -Argument CommandName}
	$name =
		try {"$($cmd.Name):$($cmd.ResolveParameter($ParameterName).Name)"}
		catch {Stop-ThrowError.ps1 "Could not find parameter '$ParameterName' for cmdlet '$CommandName'" -Argument ParameterName}
	$defaults = Get-Variable PSDefaultParameterValues -Scope $Scope -ErrorAction Ignore
	if(!$defaults)
	{
		Set-Variable PSDefaultParameterValues @{} -Scope $Scope
		$defaults = Get-Variable PSDefaultParameterValues -Scope $Scope -ErrorAction Ignore
	}
}
Process
{
	Write-Verbose "Setting default parameter '$name' to '$Value'"
	$defaults.Value[$name] = $Value
}

