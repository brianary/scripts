<#
.SYNOPSIS
Determines whether both the user and process are interactive.

.OUTPUTS
System.Boolean indicating whether the session is interactive.

.EXAMPLE
Test-Interactive.ps1

True
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param()
[Environment]::UserInteractive -and
    !([Environment]::GetCommandLineArgs() |? {$_ -ilike '-NonI*'})
