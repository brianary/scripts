<#
.SYNOPSIS
Overrides ConsoleClass window color palette entries with a preset color theme.

.LINK
Set-ConsoleColors.ps1

.LINK
https://draculatheme.com/

.LINK
https://github.com/dracula/visual-studio-code/blob/master/src/dracula.yml

.LINK
https://ethanschoonover.com/solarized/

.LINK
https://en.wikipedia.org/wiki/Solarized_(color_scheme)

.LINK
http://www.kippura.org/zenburnpage/

.LINK
https://github.com/coding-horror/ide-hot-or-not/

.LINK
https://studiostyl.es/

.EXAMPLE
Set-ConsoleColorTheme.ps1 Dracula

(sets the Dracula theme)
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
# The name of the theme to set the color table for.
[Parameter(Position=0,Mandatory=$true)]
[ValidateSet('Dracula','SolarizedDark','SolarizedLight','Zenburn')]
[string]$ThemeName,
<#
The name of the process to override the color palette for.
Used to locate the color table under HKCU:\Console\$ProcessName in the registry.
#>
[Parameter(Position=1)][Alias('ForProcessName')]
[string]$ProcessName = '%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe'
)

switch($ThemeName)
{
    Dracula {Set-ConsoleColors.ps1 -BG 0x282A36 -FG 0xF8F8F2 -EBG 0x44475A -EFG 0xFF5555 -WFG 0x8BE9FD -STR 0xF1FA8C -VAR 0xFFB86C -NUM 0x50FA7B -OP 0xFF79C6 -ProcessName $ProcessName}
    SolarizedDark {Set-ConsoleColors.ps1 -BG 0x002B36 -FG 0x93A1A1 -EFG 0xDC322F -EBG 0x073642 -WFG 0xB58900 -STR 0xEEE8D5 -VAR 0x6C71C4 -NUM 0x268BD2 -OP 0x2AA198 -ProcessName $ProcessName}
    SolarizedLight {Set-ConsoleColors.ps1 -BG 0xFDF6E3 -FG 0x93A1A1 -EFG 0xDC322F -EBG 0xEEE8D5 -WFG 0xB58900 -STR 0x073642 -VAR 0x6C71C4 -NUM 0x268BD2 -OP 0x2AA198 -ProcessName $ProcessName}
    Zenburn {Set-ConsoleColors.ps1 -BG 0x1F1F1F -FG 0xDCDCCC -EFG 0xFF80C0 -EBG 0xFFFFFF -WFG 0x7F9F7F -STR 0xCC9393 -VAR 0xFF8000 -NUM 0xCFCC8A -OP 0x9F9D6D -ProcessName $ProcessName}
}
