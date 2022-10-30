---
external help file: -help.xml
Module Name:
online version: https://docs.microsoft.com/dotnet/api/system.convert.frombase64string
schema: 2.0.0
---

# ConvertFrom-Base64.ps1

## SYNOPSIS
Converts base64-encoded text to bytes or text.

## SYNTAX

```
ConvertFrom-Base64.ps1 [-Data] <String> [[-Encoding] <String>] [-UriStyle] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
ConvertFrom-Base64.ps1 dXNlcm5hbWU6QmFkUEBzc3dvcmQ= utf8
```

username:BadP@ssword

## PARAMETERS

### -Data
The base64-encoded data.

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

### -Encoding
Uses the specified encoding to convert the bytes in the data to text.

If no encoding is provided, the data will be returned as a byte array.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Byte
Accept pipeline input: False
Accept wildcard characters: False
```

### -UriStyle
Indicates that the URI-friendly variant of the base64 algorithm should be used.
This variant, as used by JWTs, uses - instead of +, and _ instead of /, and trims the = padding at the end
to avoid extra escaping within URLs or URL-encoded data.

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

### System.String of base64-encoded text to decode.
## OUTPUTS

### System.String or System.Byte[] of decoded text or data.
## NOTES

## RELATED LINKS

[https://docs.microsoft.com/dotnet/api/system.convert.frombase64string](https://docs.microsoft.com/dotnet/api/system.convert.frombase64string)

