<#
.SYNOPSIS
Removes a value that would have been used for a parameter if none was specified, if one existed.

.PARAMETER CommandName
The name of a cmdlet, function, script, or alias to remove a default parameter value from.

.PARAMETER ParameterName
The name or alias of the parameter to remove a default value from.

.PARAMETER Scope
The scope of this default.

.INPUTS
An object with a ParameterName property that identifies a property to remove a default for.

.LINK
Add-ScopeLevel.ps1

.LINK
Stop-ThrowError.ps1

.LINK
Get-Command

.LINK
about_Scopes

.EXAMPLE
Remove-ParameterDefault.ps1 epcsv nti -Scope Global

Establishes that the -NoTypeInformation param of the Export-Csv cmdlet will revert to false
(as established by the cmdlet) if not otherwise specified, globally for the PowerShell session.

.EXAMPLE
Remove-ParameterDefault.ps1 Select-Xml Namespace

Removes any namespaces used by Select-Xml when none are given explicitly.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][ValidateNotNullOrEmpty()][Alias('CmdletName')][string] $CommandName,
[Parameter(Position=1,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][ValidateNotNullOrEmpty()][string] $ParameterName,
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
	$defaults = Get-Variable PSDefaultParameterValues -Scope $Scope -ErrorAction SilentlyContinue
}
Process
{
	if(!$defaults) {return}
	$name =
		try {"$($cmd.Name):$($cmd.ResolveParameter($ParameterName).Name)"}
		catch {Stop-ThrowError.ps1 "Could not find parameter '$ParameterName' for cmdlet '$CommandName'" -Argument ParameterName}
	Write-Verbose "Removing default parameter '$name'"
	if($defaults.Value.ContainsKey($name)) {$defaults.Value.Remove($name)}
}
