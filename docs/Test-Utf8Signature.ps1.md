---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Test-Utf8Signature.ps1

## SYNOPSIS
Returns true if a file starts with a utf-8 signature (BOM).

## SYNTAX

```
Test-Utf8Signature.ps1 [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Test-Utf8Signature.ps1 README.md
```

False

## PARAMETERS

### -Path
The file to test.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.IO.FileInfo file or similar object to test for UTF-8 validity.
## OUTPUTS

### System.Boolean indicating whether the file starts with a utf-8 signature (BOM).
## NOTES

## RELATED LINKS

[Test-FileTypeMagicNumber.ps1]()

