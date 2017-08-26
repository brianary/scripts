<#
.Synopsis
    Determines whether both the user and process are interactive.

.Outputs
    System.Boolean indicating whether the session is interactive.

.Example
    Test-Interactive.ps1

    True
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param()
[Environment]::UserInteractive -and
    !([Environment]::GetCommandLineArgs() |? {$_ -ilike '-NonI*'})
