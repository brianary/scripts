---
external help file: -help.xml
Module Name:
online version: https://www.c-sharpcorner.com/blogs/converting-to-and-from-roman-numerals1
schema: 2.0.0
---

# ConvertTo-RomanNumeral.ps1

## SYNOPSIS
Convert a number to a Roman numeral.

## SYNTAX

```
ConvertTo-RomanNumeral.ps1 [-Value] <Int32> [-Unicode] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
ConvertTo-RomanNumeral.ps1 2020
```

MMXX

### EXAMPLE 2
```
ConvertTo-RomanNumeral.ps1 8
```

VIII

## PARAMETERS

### -Value
The numeric value to convert into a Roman numeral string.

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

### -Unicode
Indicates that Unicode Roman numeral characters should be used (U+2160-U+216F).

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32 value to convert to a Roman numeral string.
## OUTPUTS

### System.String containing a Roman numeral.
## NOTES

## RELATED LINKS

[https://www.c-sharpcorner.com/blogs/converting-to-and-from-roman-numerals1](https://www.c-sharpcorner.com/blogs/converting-to-and-from-roman-numerals1)

[Get-Variable]()

