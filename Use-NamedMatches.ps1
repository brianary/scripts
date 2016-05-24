<#
.Synopsis
    Creates local variables from named matches in $Matches.
#>

#requires -version 3
[CmdletBinding()] Param()
$Matches.Keys |? {$_ -isnot [int]} |% {Set-Variable $_ $Matches.$_ -Scope 1}