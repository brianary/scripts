---
external help file: -help.xml
Module Name:
online version: https://docs.microsoft.com/dotnet/api/system.convert.tobase64string
schema: 2.0.0
---

# ConvertTo-Base64.ps1

## SYNOPSIS
Converts bytes or text to base64-encoded text.

## SYNTAX

### BinaryData
```
ConvertTo-Base64.ps1 [-Data] <Byte[]> [-UriStyle] [<CommonParameters>]
```

### TextData
```
ConvertTo-Base64.ps1 [-Text] <String> [[-Encoding] <String>] [-UriStyle] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
ConvertTo-Base64.ps1 'username:BadP@ssword' utf8
```

dXNlcm5hbWU6QmFkUEBzc3dvcmQ=

## PARAMETERS

### -Data
Binary data to convert.

```yaml
Type: Byte[]
Parameter Sets: BinaryData
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Text
Text data to convert.

```yaml
Type: String
Parameter Sets: TextData
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Encoding
The text encoding to use when converting text to binary data.

```yaml
Type: String
Parameter Sets: TextData
Aliases:

Required: False
Position: 2
Default value: Utf8
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

### System.String or System.Byte[] of data to base64-encode.
## OUTPUTS

### System.String containing the base64-encoded data.
## NOTES

## RELATED LINKS

[https://docs.microsoft.com/dotnet/api/system.convert.tobase64string](https://docs.microsoft.com/dotnet/api/system.convert.tobase64string)

