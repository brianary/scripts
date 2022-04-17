<#
.SYNOPSIS
Replaces each of the longest matching parts of a string with an embedded environment variable with that value.

.PARAMETER Value
The string to generalize with environment variable substitution.

.EXAMPLE
Compress-EnvironmentVariables.ps1 'C:\Program Files\Git\bin\git.exe'

%ProgramFiles%\Git\bin\git.exe
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0, Mandatory=$true,ValueFromPipeline=$true)][string] $Value
)
Begin
{
	$envs = Get-ChildItem env: |where Name -notin 'ProgramW6432','ALLUSERSPROFILE','PROCESSOR_LEVEL','NUMBER_OF_PROCESSORS'
	function Get-EnvMatch([string]$value)
	{
		return $envs |
			where {$Value.IndexOf($_.Value,[StringComparison]::CurrentCultureIgnoreCase) -gt -1} |
			sort {$_.Value.Length} -Descending |
			select -First 1
	}
}
Process
{
	for($env = Get-EnvMatch $Value; $env; $env = Get-EnvMatch $Value)
	{$Value = $Value -replace "$([regex]::Escape($env.Value))","%$($env.Name)%"}
	return $Value
}
