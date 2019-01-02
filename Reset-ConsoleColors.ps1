<#
.Synopsis
    Resets console color palette.
#>

#Requires -Version 3
[CmdletBinding()] Param()
Set-ConsoleColors.ps1 @{
    [ConsoleColor]'DarkMagenta' = 0x012456
    [ConsoleColor]'DarkYellow'  = 0xEEEDF0
}
