---
external help file: -help.xml
Module Name:
online version: https://www.unicode.org/Public/UCD/latest/ucd/NameAliases.txt
schema: 2.0.0
---

# Get-UnicodeByName.ps1

## SYNOPSIS
Returns characters based on Unicode code point name, GitHub short code, or HTML entity.

## SYNTAX

### Name
```
Get-UnicodeByName.ps1 [-Name] <String> [-AsEmoji] [<CommonParameters>]
```

### Update
```
Get-UnicodeByName.ps1 [-AsEmoji] [-Update] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-UnicodeByName.ps1 hyphen-minus
```

-

### EXAMPLE 2
```
Get-UnicodeByName.ps1 slash
```

/

### EXAMPLE 3
```
Get-UnicodeByName.ps1 :zero:
```

\[0\]

### EXAMPLE 4
```
Get-UnicodeByName.ps1 '&amp;'
```

&

### EXAMPLE 5
```
Get-UnicodeByName.ps1 BEL
```

(beeps)

## PARAMETERS

### -Name
The name or alias of a Unicode character.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -AsEmoji
Appends a U+FE0F VARIATION SELECTOR-16 suffix to the character, which suggests an emoji presentation
for characters that support both a simple text presentation as well as a color emoji-style one.

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

### -Update
Update the character name database.

```yaml
Type: SwitchParameter
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String of a character name.
## OUTPUTS

### System.String of the character(s) referenced by name.
## NOTES

## RELATED LINKS

[https://www.unicode.org/Public/UCD/latest/ucd/NameAliases.txt](https://www.unicode.org/Public/UCD/latest/ucd/NameAliases.txt)

[https://html.spec.whatwg.org/multipage/named-characters.html](https://html.spec.whatwg.org/multipage/named-characters.html)

