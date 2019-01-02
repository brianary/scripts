<#
.Synopsis
    Sets console colors.

.Parameter ForegroundColor
    The integer (A)RGB value to use for foreground text.
    Typically this is set to the "DarkYellow" (6) palette entry via $Host.UI.RawUI.ForegroundColor.

.Parameter BackgroundColor
    The integer (A)RGB value to use for background text.
    Typically this is set to the "DarkMagenta" (5) palette entry via $Host.UI.RawUI.ForegroundColor.

.Parameter ErrorForegroundColor
    The integer (A)RGB value to use for error foreground text.
    Typically this is set to the "Red" (12) palette entry via $Host.PrivateData.ErrorForegroundColor.

.Parameter ErrorBackgroundColor
    The integer (A)RGB value to use for error background text.
    Typically this is set to the "Black" (0) palette entry via $Host.PrivateData.ErrorBackgroundColor.

.Parameter WarningForegroundColor
    The integer (A)RGB value to use for foreground text.
    Typically this is set to the "Yellow" (14) palette entry via $Host.PrivateData.WarningForegroundColor.

.Parameter WarningBackgroundColor
    The integer (A)RGB value to use for background text.
    Typically this is set to the "Black" (0) palette entry via $Host.PrivateData.WarningnBackgroundColor.

.Parameter DebugForegroundColor
    The integer (A)RGB value to use for foreground text.
    Typically this is set to the "Yellow" (14) palette entry via $Host.PrivateData.DebugForegroundColor.

.Parameter DebugBackgroundColor
    The integer (A)RGB value to use for background text.
    Typically this is set to the "Black" (0) palette entry via $Host.PrivateData.DebugBackgroundColor.

.Parameter VerboseForegroundColor
    The integer (A)RGB value to use for foreground text.
    Typically this is set to the "Yellow" (14) palette entry via $Host.PrivateData.VerboseForegroundColor.

.Parameter VerboseBackgroundColor
    The integer (A)RGB value to use for background text.
    Typically this is set to the "Black" (0) palette entry via $Host.PrivateData.VerboseBackgroundColor.

.Parameter ProgressForegroundColor
    The integer (A)RGB value to use for foreground text.
    Typically this is set to the "Yellow" (14) palette entry via $Host.PrivateData.ProgressForegroundColor.

.Parameter ProgressBackgroundColor
    The integer (A)RGB value to use for background text.
    Typically this is set to the "DarkCyan" (3) palette entry via $Host.PrivateData.ProgressBackgroundColor.

.Parameter StringForegroundColor
    The integer (A)RGB value to use for foreground text.
    This is set to the "DarkCyan" (3) palette entry.

.Parameter CommandForegroundColor
    The integer (A)RGB value to use for foreground text.
    This is set to the "Yellow" (14) palette entry.

.Parameter VariableForegroundColor
    The integer (A)RGB value to use for foreground text.
    This is set to the "Green" (10) palette entry.

.Parameter OperatorForegroundColor
    The integer (A)RGB value to use for foreground text.
    This is set to the "DarkGray" (8) palette entry.

.Parameter ColorTable
    A hashtable of ConsoleColor enum values to RGB ints to set the palette entry to.
    Any values from the ConsoleColor enumeration that are not included will be removed
    from the registry color table.

.Parameter ProcessName
    The name of the process to override the color palette for.
    Used to locate the color table under HKCU:\Console\$ProcessName in the registry.

.Notes
    ConsoleClass window palette

     # Hex RGB Name        CMD COLOR    Use
     0 #000000 Black       Black        ErrorBG, WarningBG, DebugBG, VerboseBG
     1 #000080 DarkBlue    Blue
     2 #008000 DarkGreen   Green
     3 #008080 DarkCyan    Aqua         ProgressBG, StringFG*
     4 #800000 DarkRed     Red
     5 #800080 DarkMagenta Purple       BG; PowerShell default override #012456
     6 #808000 DarkYellow  Yellow       FG; PowerShell default override #EEEDF0
     7 #C0C0C0 Gray        White
     8 #808080 DarkGray    Gray         OperatorFG*
     9 #0000FF Blue        Light Blue
    10 #00FF00 Green       Light Green  VariableFG*
    11 #00FFFF Cyan        Light Aqua
    12 #FF0000 Red         Light Red    ErrorFG
    13 #FF00FF Magenta     Light Purple
    14 #FFFF00 Yellow      Light Yellow CommandFG*, DebugFG, ProgressFG, VerboseFG, WarningFG
    15 #FFFFFF White       Bright White

    * apparently hard-coded palette entry

.Example
    Set-ConsoleColors.ps1 -BG 0x282A36 -FG 0xF8F8F2 -EBG 0x44475A -EFG 0xFF5555 -VAR 0xFFB86C

    Sets the $Host.UI.RawUI.ForegroundColor color entry to #282A36,
    $Host.UI.RawUI.BackgroundColor color entry to #F8F8F2,
    $Host.PrivateData.ErrorBackgroundColor color entry to #44475A,
    $Host.PrivateData.ErrorForegroundColor color entry to #FF5555,
    and "Green" (the hard-coded variable color) to #FFB86C.

.Example
    Set-ConsoleColors.ps1 @{[ConsoleColor]'DarkMagenta' = 0x012456; [ConsoleColor]'DarkYellow' = 0xEEEDF0}

    Resets default PowerShell colors by removing all overrides, except setting
    DarkMagenta to #012456 and DarkYellow to #EEEDF0.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(ParameterSetName='ByContext')][Alias('FG')][int]$ForegroundColor,
[Parameter(ParameterSetName='ByContext')][Alias('BG')][int]$BackgroundColor,
[Parameter(ParameterSetName='ByContext')][Alias('EFG')][int]$ErrorForegroundColor,
[Parameter(ParameterSetName='ByContext')][Alias('EBG')][int]$ErrorBackgroundColor,
[Parameter(ParameterSetName='ByContext')][Alias('WFG')][int]$WarningForegroundColor,
[Parameter(ParameterSetName='ByContext')][Alias('WBG')][int]$WarningBackgroundColor,
[Parameter(ParameterSetName='ByContext')][Alias('DFG')][int]$DebugForegroundColor,
[Parameter(ParameterSetName='ByContext')][Alias('DBG')][int]$DebugBackgroundColor,
[Parameter(ParameterSetName='ByContext')][Alias('VFG')][int]$VerboseForegroundColor,
[Parameter(ParameterSetName='ByContext')][Alias('VBG')][int]$VerboseBackgroundColor,
[Parameter(ParameterSetName='ByContext')][Alias('PFG')][int]$ProgressForegroundColor,
[Parameter(ParameterSetName='ByContext')][Alias('PBG')][int]$ProgressBackgroundColor,
[Parameter(ParameterSetName='ByContext')][Alias('STR')][int]$StringForegroundColor,
[Parameter(ParameterSetName='ByContext')][Alias('CMD')][int]$CommandForegroundColor,
[Parameter(ParameterSetName='ByContext')][Alias('VAR')][int]$VariableForegroundColor,
[Parameter(ParameterSetName='ByContext')][Alias('OP')][int]$OperatorForegroundColor,
[Parameter(ParameterSetName='ByColorTable',Position=0,Mandatory=$true)][hashtable]$ColorTable,
[Alias('ForProcessName')][string]$ProcessName = '%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe'
)

function ConvertTo-ABGR([Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][int]$RGB)
{ # ARGB int -> ABGR int
    $ABGR = [BitConverter]::GetBytes($RGB)
    $ABGR[0],$ABGR[2] = $ABGR[2],$ABGR[0]
    return [BitConverter]::ToInt32($ABGR,0)
}

function Get-ColorTable([Parameter(Position=0,Mandatory=$true)][Collections.IDictionary]$Parameters)
{
    $usagemap = @{}
    $colormap = @{}
    foreach($param in $Parameters.Keys)
    {
        [ConsoleColor]$color = switch -Wildcard ($param)
        {
            'String*'     {'DarkCyan'}
            'Command*'    {'Yellow'}
            'Variable*'   {'Green'}
            'Operator*'   {'DarkGray'}
            '????ground*' {$Host.UI.RawUI.$param}
            default       {$Host.PrivateData.$param}
        }
        $value = Get-Variable $param -ValueOnly |ConvertTo-ABGR
        if($usagemap.ContainsKey($color))
        {
            if($value -ne $colormap[$color])
            {Write-Warning "Both $($usagemap[$color]) and $param map to '$color' palette entry, $param ignored."}
            continue
        }
        [void]$usagemap.Add($color,$param)
        [void]$colormap.Add($color,$value)
    }
    Write-Verbose "Color Context: $(Out-String -InputObject $usagemap)"
    return $colormap
}

function Set-ColorTable([hashtable]$ColorTable)
{
    foreach($color in [Enum]::GetValues([ConsoleColor]))
    {
        if($ColorTable.ContainsKey($color))
        {
            Set-ItemProperty "HKCU:\Console\$ProcessName" ('ColorTable{0:00}' -f ([int]$color)) $ColorTable[$color] -Type Dword
        }
        else
        {
            Remove-ItemProperty "HKCU:\Console\$ProcessName" ('ColorTable{0:00}' -f ([int]$color)) -EA 0
        }
    }
}

if($PSCmdlet.ParameterSetName -eq 'ByContext') {$ColorTable = Get-ColorTable $PSBoundParameters}
else {foreach($color in @($ColorTable.Keys)) {$ColorTable[$color] = $ColorTable[$color] |ConvertTo-ABGR}}

Set-ColorTable $ColorTable
