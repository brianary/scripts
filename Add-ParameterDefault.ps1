<#
.Synopsis
	Appends or creates a value to use for the specified cmdlet parameter to use when one is not specified.

.Parameter CommandName
	The name of a cmdlet, function, script, or alias to include a default parameter value for.

.Parameter ParameterName
	The name or alias of the parameter to include a default value for.

.Parameter Value
	The value to include as a default.

.Parameter Scope
	The scope of this default.

.Inputs
	System.Object containing a default value to include.

.Link
	Add-ScopeLevel.ps1

.Link
	Stop-ThrowError.ps1

.Link
	Get-Command

.Link
	about_Scopes

.Example
	Add-ParameterDefault.ps1 epcsv nti $true -Scope Global

	Establishes that the -NoTypeInformation param of the Export-Csv cmdlet will be true if not otherwise specified,
	globally for the PowerShell session.

.Example
	Add-ParameterDefault.ps1 Select-Xml Namespace @{svg = 'http://www.w3.org/2000/svg'}

	Adds the SVG namespace to any existing namespaces used by Select-Xml when none are given explicitly.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][ValidateNotNullOrEmpty()][Alias('CmdletName')][string] $CommandName,
[Parameter(Position=1,Mandatory=$true)][ValidateNotNullOrEmpty()][string] $ParameterName,
[Parameter(Position=2,Mandatory=$true,ValueFromPipeline=$true)] $Value,
[string] $Scope = 'Local'
)
Begin
{
	$Scope = Add-ScopeLevel.ps1 $Scope
	$cmd = Get-Command $CommandName -ErrorAction SilentlyContinue
	if(!$cmd) {Stop-ThrowError.ps1 "Could not find command '$CommandName'" -Argument CommandName}
	if($cmd.CommandType -eq 'Alias') {$cmd = Get-Command $cmd.ResolvedCommandName}
	if($cmd.CommandType -notin 'Cmdlet','ExternalScript','Function','Script')
	{Stop-ThrowError.ps1 "Command '$CommandName' ($($cmd.CommandType)) not supported" -Argument CommandName}
	$name =
		try {"$($cmd.Name):$($cmd.ResolveParameter($ParameterName).Name)"}
		catch {Stop-ThrowError.ps1 "Could not find parameter '$ParameterName' for cmdlet '$CommandName'" -Argument ParameterName}
	$defaults = Get-Variable PSDefaultParameterValues -Scope $Scope -ErrorAction SilentlyContinue
	if(!$defaults)
	{
		Set-Variable PSDefaultParameterValues @{} -Scope $Scope
		$defaults = Get-Variable PSDefaultParameterValues -Scope $Scope -ErrorAction SilentlyContinue
	}
}
Process
{
	Write-Verbose "Setting default parameter '$name' to '$Value'"
	if($defaults.Value.ContainsKey($name)) {$defaults.Value[$name] += $Value}
	else {$defaults.Value[$name] = $Value}
}
