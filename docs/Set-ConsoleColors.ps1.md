---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Set-ConsoleColors.ps1

## SYNOPSIS
Overrides ConsoleClass window color palette entries with RGB values.

## SYNTAX

### ByContext
```
Set-ConsoleColors.ps1 [-ForegroundColor <Int32>] [-BackgroundColor <Int32>] [-ErrorForegroundColor <Int32>]
 [-ErrorBackgroundColor <Int32>] [-WarningForegroundColor <Int32>] [-WarningBackgroundColor <Int32>]
 [-DebugForegroundColor <Int32>] [-DebugBackgroundColor <Int32>] [-VerboseForegroundColor <Int32>]
 [-VerboseBackgroundColor <Int32>] [-ProgressForegroundColor <Int32>] [-ProgressBackgroundColor <Int32>]
 [-StringForegroundColor <Int32>] [-CommandForegroundColor <Int32>] [-VariableForegroundColor <Int32>]
 [-NumberForegroundColor <Int32>] [-OperatorForegroundColor <Int32>] [-ProcessName <String>]
 [<CommonParameters>]
```

### ByColorTable
```
Set-ConsoleColors.ps1 [-ColorTable] <Hashtable> [-ProcessName <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Set-ConsoleColors.ps1 -BG 0x282A36 -FG 0xF8F8F2 -EBG 0x44475A -EFG 0xFF5555 -VAR 0xFFB86C
```

Sets the $Host.UI.RawUI.ForegroundColor color entry to #282A36,
$Host.UI.RawUI.BackgroundColor color entry to #F8F8F2,
$Host.PrivateData.ErrorBackgroundColor color entry to #44475A,
$Host.PrivateData.ErrorForegroundColor color entry to #FF5555,
and "Green" (the hard-coded variable color) to #FFB86C.

### EXAMPLE 2
```
Set-ConsoleColors.ps1 @{[ConsoleColor]'DarkMagenta' = 0x012456; [ConsoleColor]'DarkYellow' = 0xEEEDF0}
```

Resets default PowerShell colors by removing all overrides, except setting
DarkMagenta to #012456 and DarkYellow to #EEEDF0.

## PARAMETERS

### -ForegroundColor
The integer (A)RGB value to use for foreground text.
Typically this is set to the "DarkYellow" (6) palette entry via $Host.UI.RawUI.ForegroundColor.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: FG

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackgroundColor
The integer (A)RGB value to use for background text.
Typically this is set to the "DarkMagenta" (5) palette entry via $Host.UI.RawUI.ForegroundColor.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: BG

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ErrorForegroundColor
The integer (A)RGB value to use for error foreground text.
Typically this is set to the "Red" (12) palette entry via $Host.PrivateData.ErrorForegroundColor.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: EFG

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ErrorBackgroundColor
The integer (A)RGB value to use for error background text.
Typically this is set to the "Black" (0) palette entry via $Host.PrivateData.ErrorBackgroundColor.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: EBG

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WarningForegroundColor
The integer (A)RGB value to use for warning foreground text.
Typically this is set to the "Yellow" (14) palette entry via $Host.PrivateData.WarningForegroundColor.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: WFG

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WarningBackgroundColor
The integer (A)RGB value to use for warning background text.
Typically this is set to the "Black" (0) palette entry via $Host.PrivateData.WarningnBackgroundColor.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: WBG

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DebugForegroundColor
The integer (A)RGB value to use for debug foreground text.
Typically this is set to the "Yellow" (14) palette entry via $Host.PrivateData.DebugForegroundColor.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: DFG

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DebugBackgroundColor
The integer (A)RGB value to use for debug background text.
Typically this is set to the "Black" (0) palette entry via $Host.PrivateData.DebugBackgroundColor.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: DBG

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -VerboseForegroundColor
The integer (A)RGB value to use for verbose foreground text.
Typically this is set to the "Yellow" (14) palette entry via $Host.PrivateData.VerboseForegroundColor.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: VFG

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -VerboseBackgroundColor
The integer (A)RGB value to use for verbose background text.
Typically this is set to the "Black" (0) palette entry via $Host.PrivateData.VerboseBackgroundColor.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: VBG

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressForegroundColor
The integer (A)RGB value to use for progress foreground text.
Typically this is set to the "Yellow" (14) palette entry via $Host.PrivateData.ProgressForegroundColor.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: PFG

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressBackgroundColor
The integer (A)RGB value to use for progress background text.
Typically this is set to the "DarkCyan" (3) palette entry via $Host.PrivateData.ProgressBackgroundColor.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: PBG

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -StringForegroundColor
The integer (A)RGB value to use for string literal foreground text.
This is set to the "DarkCyan" (3) palette entry.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: STR

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommandForegroundColor
The integer (A)RGB value to use for command foreground text.
This is set to the "Yellow" (14) palette entry.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: CMD

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -VariableForegroundColor
The integer (A)RGB value to use for variable foreground text.
This is set to the "Green" (10) palette entry.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: VAR

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -NumberForegroundColor
The integer (A)RGB value to use for numeric literal foreground text.
This is set to the "White" (15) palette entry.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: NUM

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OperatorForegroundColor
The integer (A)RGB value to use for operator foreground text.
This is set to the "DarkGray" (8) palette entry.

```yaml
Type: Int32
Parameter Sets: ByContext
Aliases: OP

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ColorTable
A hashtable of ConsoleColor enum values to RGB ints to set the palette entry to.
Any values from the ConsoleColor enumeration that are not included will be removed
from the registry color table.

```yaml
Type: Hashtable
Parameter Sets: ByColorTable
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProcessName
The name of the process to override the color palette for.
Used to locate the color table under HKCU:\Console\$ProcessName in the registry.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ForProcessName

Required: False
Position: Named
Default value: %SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
## NOTES
ConsoleClass window palette

 # Hex RGB Name        CMD COLOR    PowerShell Usage
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
15 #FFFFFF White       Bright White NumberFG*

* apparently hard-coded palette entry

Tip: Since DarkCyan is used (by default) as both a background and a foreground,
special care must be taken in choosing that it contrasts well with both the default
background color and the progress foreground color.

## RELATED LINKS

[Set-ItemProperty]()

[Remove-ItemProperty]()

[Get-Variable]()

[https://stackoverflow.com/questions/36116326/programmatically-change-powershells-16-default-console-colours/36118181#36118181](https://stackoverflow.com/questions/36116326/programmatically-change-powershells-16-default-console-colours/36118181#36118181)

[https://docs.microsoft.com/dotnet/api/system.bitconverter.getbytes#System_BitConverter_GetBytes_System_Int32_](https://docs.microsoft.com/dotnet/api/system.bitconverter.getbytes#System_BitConverter_GetBytes_System_Int32_)

