---
external help file: -help.xml
Module Name:
online version: https://www.nerdfonts.com/cheat-sheet
schema: 2.0.0
---

# Show-Status.ps1

## SYNOPSIS
Displays requested system status values using powerline font characters.

## SYNTAX

```
Show-Status.ps1 [-Status] <String[]> [-Separator <String>] [-ForegroundColor <ConsoleColor>]
 [-BackgroundColor <ConsoleColor>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Show-Status.ps1 UserName HomeDirectory -Separator ' * '
```

( MyUserName * C:\Users\MyUserName )
(but using powerline graphics)

## PARAMETERS

### -Status
The format to serialize the date as.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Separator
The separator to use between formatted dates.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: " $(Get-Unicode.ps1 0x2022) "
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForegroundColor
The foreground console color to use.

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: Named
Default value: $host.UI.RawUI.BackgroundColor
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackgroundColor
The background console color to use.

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: Named
Default value: $host.UI.RawUI.ForegroundColor
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[https://www.nerdfonts.com/cheat-sheet](https://www.nerdfonts.com/cheat-sheet)

[Get-Unicode.ps1]()

