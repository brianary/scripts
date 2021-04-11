---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-ConsoleColors.ps1

## SYNOPSIS
Gets current console color details.

## SYNTAX

```
Get-ConsoleColors.ps1 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-ConsoleColors.ps1 |Format-Table -AutoSize
```

Value Name        RgbHex  Color                            PowerShellUsage
----- ----        ------  -----                            ---------------
    0 Black       #000000 Color \[A=0, R=0, G=0, B=0\]       {ErrorBackgroundColor, WarningBackgroundColor, DebugBackgroundColor, VerboseBackgroundColor}
    1 DarkBlue    #800000 Color \[A=0, R=128, G=0, B=0\]     {}
    2 DarkGreen   #008000 Color \[A=0, R=0, G=128, B=0\]     {}
    3 DarkCyan    #808000 Color \[A=0, R=128, G=128, B=0\]   {StringForegroundColor, ProgressBackgroundColor}
    4 DarkRed     #000080 Color \[A=0, R=0, G=0, B=128\]     {}
    5 DarkMagenta #562401 Color \[A=0, R=86, G=36, B=1\]     {BackgroundColor}
    6 DarkYellow  #F0EDEE Color \[A=0, R=240, G=237, B=238\] {ForegroundColor}
    7 Gray        #C0C0C0 Color \[A=0, R=192, G=192, B=192\] {}
    8 DarkGray    #808080 Color \[A=0, R=128, G=128, B=128\] {OperatorForegroundColor}
    9 Blue        #FF0000 Color \[A=0, R=255, G=0, B=0\]     {}
   10 Green       #00FF00 Color \[A=0, R=0, G=255, B=0\]     {VariableForegroundColor}
   11 Cyan        #FFFF00 Color \[A=0, R=255, G=255, B=0\]   {}
   12 Red         #0000FF Color \[A=0, R=0, G=0, B=255\]     {ErrorForegroundColor}
   13 Magenta     #FF00FF Color \[A=0, R=255, G=0, B=255\]   {}
   14 Yellow      #00FFFF Color \[A=0, R=0, G=255, B=255\]   {CommandForegroundColor, WarningForegroundColor, DebugForegroundColor, VerboseForegroundColor...}
   15 White       #FFFFFF Color \[Transparent\]              {NumberForegroundColor, NumberForegroundColor}

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject of each console color setting.
## NOTES

## RELATED LINKS
