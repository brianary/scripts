---
external help file: -help.xml
Module Name:
online version: https://docs.microsoft.com/dotnet/api/system.numerics.biginteger.parse#System_Numerics_BigInteger_Parse_System_String_System_Globalization_NumberStyles_
schema: 2.0.0
---

# ConvertFrom-Hex.ps1

## SYNOPSIS
Convert a string of hexadecimal digits into a byte array.

## SYNTAX

```
ConvertFrom-Hex.ps1 [-InputObject] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
ConvertFrom-Hex.ps1 'EF BB BF'
```

239
187
191

### EXAMPLE 2
```
[text.encoding]::UTF8.GetString((ConvertFrom-Hex.ps1 0x25504446))
```

%PDF

### EXAMPLE 3
```
'{0:X2} {1:X2} {2:X2}' -f (ConvertFrom-Hex.ps1 c0ffee)
```

C0 FF EE

## PARAMETERS

### -InputObject
A string of hex digits.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String of hex digits.
## OUTPUTS

### System.Byte[] of bytes parsed from hex digits.
## NOTES

## RELATED LINKS

[https://docs.microsoft.com/dotnet/api/system.numerics.biginteger.parse#System_Numerics_BigInteger_Parse_System_String_System_Globalization_NumberStyles_](https://docs.microsoft.com/dotnet/api/system.numerics.biginteger.parse#System_Numerics_BigInteger_Parse_System_String_System_Globalization_NumberStyles_)

[https://docs.microsoft.com/dotnet/api/system.array.reverse#System_Array_Reverse_System_Array_](https://docs.microsoft.com/dotnet/api/system.array.reverse#System_Array_Reverse_System_Array_)

