<#
.Synopsis
	Returns a list of global dotnet tools.
#>

#Requires -Version 3
[CmdletBinding()] Param()

Use-Command.ps1 dotnet "$env:ProgramFiles\dotnet\dotnet.exe" -cinst dotnet-sdk

foreach($line in dotnet tool list -g |select -Skip 2)
{
	$package,$version,$commands = $line -split '\s\s+',3
	[pscustomobject]@{
		Package = $package
		Version = [version]$version
		Commands = $commands
	}
}
