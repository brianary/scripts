<#
.Synopsis
    Determines whether both the user and process are interactive.
#>

#requires -Version 3
[CmdletBinding()] Param()
[Environment]::UserInteractive -and
    !([Environment]::GetCommandLineArgs() |? {$_ -ilike '-NonI*'})