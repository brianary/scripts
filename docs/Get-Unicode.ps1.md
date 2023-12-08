---
external help file: -help.xml
Module Name:
online version: https://docs.microsoft.com/dotnet/api/system.char.convertfromutf32
schema: 2.0.0
---

# Get-Unicode.ps1

## SYNOPSIS
Returns the (UTF-16) .NET string for a given Unicode codepoint, which may be a surrogate pair.

## SYNTAX

```
Get-Unicode.ps1 [-Codepoint] <Int32> [-AsEmoji] [-AsStringLiteral] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
"$(Get-Unicode 0x1F5A7) Network"
```

\<three networked computers\> Network

## PARAMETERS

### -Codepoint
The integer value of a Unicode codepoint to convert into a .NET string.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
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

### -AsStringLiteral
Outputs the codepoint as a usable PowerShell string literal.

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

## OUTPUTS

## NOTES
An alias of U+ allows you to interpolate a codepoint like this "$(U+ 0x1F5A7) Network"

## RELATED LINKS

[https://docs.microsoft.com/dotnet/api/system.char.convertfromutf32](https://docs.microsoft.com/dotnet/api/system.char.convertfromutf32)

