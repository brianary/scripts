---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Write-VisibleString.ps1

## SYNOPSIS
Displays a string, showing nonprintable characters.

## SYNTAX

```
Write-VisibleString.ps1 [-InputObject] <Object> [-AsRunes] [-UseSymbols] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Write-VisibleString.ps1 "a`tb`nc"
```

a 09 b 0a c

## PARAMETERS

### -InputObject
The string to show.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -AsRunes
Parse Runes from the string rather than Chars.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseSymbols
Print control characters as control picture symbols rather than hex values.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### System.Object to serialize with nonprintable characters made visible as a hex pair.
## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS
