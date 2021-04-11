---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Test-BinaryFile.ps1

## SYNOPSIS
Indicates that a file contains binary data.

## SYNTAX

```
Test-BinaryFile.ps1 [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Test-BinaryFile.ps1 avatar.jpg
```

True

### EXAMPLE 2
```
Test-BinaryFile.ps1 README.md
```

False

## PARAMETERS

### -Path
A file to test.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Boolean indicating that the file contains binary data.
## NOTES

## RELATED LINKS

[Test-TextFile.ps1]()

