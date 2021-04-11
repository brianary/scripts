---
external help file: -help.xml
Module Name:
online version: https://en.wikipedia.org/wiki/Magic_number_(programming)
schema: 2.0.0
---

# Test-MagicNumber.ps1

## SYNOPSIS
Tests a file for a "magic number" (identifying sequence of bytes) at a given location.

## SYNTAX

```
Test-MagicNumber.ps1 [-Bytes] <Byte[]> [[-Path] <String>] [-Offset <Int32>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Test-MagicNumber.ps1 0xEF,0xBB,0xBF README.md
```

True if a utf-8 signature (or "BOM", byte-order-mark) is found.

### EXAMPLE 2
```
Test-MagicNumber.ps1 0x0D,0x0A README.md -Offset -2
```

True if README.md ends with a Windows line-ending.

### EXAMPLE 3
```
Test-MagicNumber.ps1 0x50,0x4B download123543
```

True if download123543 starts with a PK ZIP magic number ("PK"), and is therefore likely ZIP data.

## PARAMETERS

### -Bytes
A list of byte values to compare against those read from the file.

```yaml
Type: Byte[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
A file to look for the bytes in.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Offset
The number bytes into the file to begin reading the bytes to compare.
Use a negative number to count from the end of the file.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String path of a file to read.
## OUTPUTS

### System.Boolean affirming that the bytes provided were found at the position given in the specified file.
## NOTES

## RELATED LINKS

[https://en.wikipedia.org/wiki/Magic_number_(programming)](https://en.wikipedia.org/wiki/Magic_number_(programming))

[Get-Content]()

