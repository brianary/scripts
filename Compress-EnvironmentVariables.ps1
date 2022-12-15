<#
.SYNOPSIS
Replaces each of the longest matching parts of a string with an embedded environment variable with that value.

.DESCRIPTION
This provides a way to un-expand environment variables in a string, to make it smaller,
or more portable, or to make the use of specific paths more understandable.

The output of this script can be passed to [Environment]::ExpandEnvironmentVariables()
to get the original string (provided the variable values are the same).

.INPUTS
System.String containing text to un-expand environment variables in.

.OUTPUTS
System.String with any possible environment varibles in place of their expanded text,
which could be passed to [Environment]::ExpandEnvironmentVariables().

.FUNCTIONALITY
EnvironmentVariables

.EXAMPLE
Compress-EnvironmentVariables.ps1 'C:\Program Files\Git\bin\git.exe'

%ProgramFiles%\Git\bin\git.exe
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
# The string to generalize with environment variable substitution.
[Parameter(Position=0, Mandatory=$true,ValueFromPipeline=$true)][string] $Value
)
Begin
{
	$envs = [Environment]::GetEnvironmentVariables().GetEnumerator() |
		Where-Object Key -notin 'ProgramW6432','ALLUSERSPROFILE','PROCESSOR_LEVEL','NUMBER_OF_PROCESSORS'
	function Get-EnvMatch([string] $Text)
	{
		return $envs |
			Where-Object {$Text.IndexOf($_.Value,[StringComparison]::CurrentCultureIgnoreCase) -gt -1} |
			Sort-Object {$_.Value.Length} -Descending |
			Select-Object -First 1
	}
}
Process
{
	for($env = Get-EnvMatch $Value; $env; $env = Get-EnvMatch $Value)
	{$Value = $Value -replace "$([regex]::Escape($env.Value))","%$($env.Key)%"}
	return $Value
}
