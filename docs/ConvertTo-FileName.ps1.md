---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# ConvertTo-FileName.ps1

## SYNOPSIS
Returns a valid and safe filename from a given string.

## SYNTAX

```
ConvertTo-FileName.ps1 [[-OutputBlock] <String>] [[-Replacement] <Rune>] [[-IncludeChars] <Char[]>]
 [[-ExcludeChars] <Char[]>] [[-IncludeRunes] <Rune[]>] [[-ExcludeRunes] <Rune[]>] [-CurrentPlatformOnly]
 [-InputObject] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
'app*.log' |ConvertTo-FileName.ps1
```

app_.log

### EXAMPLE 2
```
' |ConvertTo-FileName.ps1 -CurrentPlatformOnly
```

one_two-_three_

### EXAMPLE 3
```
'app-${value}.config' |ConvertTo-FileName.ps1 Ascii -ExcludeChars '%','$','{','}','`'
```

app-_value_.config

## PARAMETERS

### -OutputBlock
Allows limiting the filename to either ASCII or Basic Multilingual Plane characters, if specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Replacement
The character to use to replace a range of invalid characters.

```yaml
Type: Rune
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: '_'[0]
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeChars
Characters to include (overrides exclusions).

```yaml
Type: Char[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeChars
Characters to exclude.

```yaml
Type: Char[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeRunes
Runes to include (overrides excludes).

```yaml
Type: Rune[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeRunes
Runes to exclude.

```yaml
Type: Rune[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -CurrentPlatformOnly
Indicates that only characters invalid for the current platform should be excluded by default,
otherwise invalid characters from any platform will be excluded by default (unless overridden).

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

### -InputObject
The string value to sanitize for use as a filename.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: True (ByValue)
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

### System.String containing a filename that may contain invalid characters.
## OUTPUTS

### System.String containing a filename without any invalid characters.
## NOTES

## RELATED LINKS
