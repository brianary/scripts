---
external help file: -help.xml
Module Name:
online version: https://docs.microsoft.com/dotnet/api/system.char.issurrogatepair
schema: 2.0.0
---

# ConvertTo-SafeEntities.ps1

## SYNOPSIS
Encode text as XML/HTML, escaping all characters outside 7-bit ASCII.

## SYNTAX

```
ConvertTo-SafeEntities.ps1 [-InputObject] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
"$([char]0xD83D)$([char]0xDCA1) File $([char]0x2192) Save" |ConvertTo-SafeEntities.ps1
```

&#x1F4A1; File &#x2192; Save

This shows a UTF-16 surrogate pair, used internally by .NET strings, which is combined
into a single entity reference.

### EXAMPLE 2
```
"ETA: $([char]0xBD) hour" |ConvertTo-SafeEntities.ps1
```

ETA: &#xBD; hour

## PARAMETERS

### -InputObject
An HTML or XML string that may include emoji or other Unicode characters outside
the 7-bit ASCII range.

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

### System.String of HTML or XML data to encode.
## OUTPUTS

### System.String of HTML or XML data, encoded.
## NOTES

## RELATED LINKS

[https://docs.microsoft.com/dotnet/api/system.char.issurrogatepair](https://docs.microsoft.com/dotnet/api/system.char.issurrogatepair)

[https://docs.microsoft.com/dotnet/api/system.char.converttoutf32](https://docs.microsoft.com/dotnet/api/system.char.converttoutf32)

