<#
.Synopsis
    Overrides ConsoleClass window color palette entries with a preset color theme.

.Parameter ThemeName
    The name of the theme to set the color table for.

.Link
    Set-ConsoleColors.ps1

.Link
    https://draculatheme.com/

.Link
    https://ethanschoonover.com/solarized/

.Link
    https://en.wikipedia.org/wiki/Solarized_(color_scheme)

.Link
    http://www.kippura.org/zenburnpage/

.Example
    Set-ConsoleColorTheme.ps1 Dracula

    (sets the Dracula theme)
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)]
[ValidateSet('Dracula','SolarizedDark','SolarizedLight','Zenburn')]
[string]$ThemeName
)

switch($ThemeName)
{
    Dracula {Set-ConsoleColors.ps1 -BG 0x282A36 -FG 0xF8F8F2 -EBG 0x44475A -EFG 0xFF5555 -WFG 0x8BE9FD -STR 0xF1FA8C -VAR 0xFFB86C -OP 0xFF79C6}
    SolarizedDark {Set-ConsoleColors.ps1 -BG 0x002B36 -FG 0x93A1A1 -EFG 0xDC322F -EBG 0x073642 -WFG 0xB58900 -STR 0xEEE8D5 -VAR 0x6C71C4 -OP 0x2AA198}
    SolarizedLight {Set-ConsoleColors.ps1 -BG 0xFDF6E3 -FG 0x93A1A1 -EFG 0xDC322F -EBG 0xEEE8D5 -WFG 0xB58900 -STR 0x073642 -VAR 0x6C71C4 -OP 0x2AA198}
    Zenburn {Set-ConsoleColors.ps1 -BG 0x1F1F1F -FG 0xDCDCCC -EFG 0xFF80C0 -EBG 0xFFFFFF -WFG 0x7F9F7F -STR 0xCC9393 -VAR 0xFF8000 -OP 0x9F9D6D}
}
