---
external help file: -help.xml
Module Name:
online version: https://en.wikipedia.org/wiki/List_of_file_signatures
schema: 2.0.0
---

# Test-FileTypeMagicNumber.ps1

## SYNOPSIS
Tests for a given common file type by magic number.

## SYNTAX

```
Test-FileTypeMagicNumber.ps1 [-FileType] <String> [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Test-FileTypeMagicNumber.ps1 utf8 README.md
```

True if a utf-8 signature (or "BOM", byte-order-mark) is found.

### EXAMPLE 2
```
Test-FileTypeMagicNumber.ps1 png avatar.png
```

True if avatar.png contains the expected png magic number.

## PARAMETERS

### -FileType
The file type to test for.

This is generally the MIME subtype or Unicode text encoding, with some exceptions.

Several types require the presence of an optional header or prefix for positive identification of a file type,
such as "\<?xml" for xml or "%YAML " for yaml.

Text files require either a UTF BOM/SIG, or must end with a newline (U+000A) and not contain any NUL (U+0000)
characters (in the first 1KB sampled), or just not contain any characters above 7-bit US-ASCII in the first 1KB.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The file to test.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String path of a file to test.
## OUTPUTS

### System.Boolean affirming that the magic number for the specified file type was found.
## NOTES

## RELATED LINKS

[https://en.wikipedia.org/wiki/List_of_file_signatures](https://en.wikipedia.org/wiki/List_of_file_signatures)

[https://blogs.msdn.microsoft.com/sergey_babkins_blog/2015/01/02/powershell-script-blocks-are-not-closures/](https://blogs.msdn.microsoft.com/sergey_babkins_blog/2015/01/02/powershell-script-blocks-are-not-closures/)

[http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_206](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_206)

[http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_403](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_403)

[Test-MagicNumber.ps1]()

