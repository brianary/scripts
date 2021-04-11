---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Test-TextFile.ps1

## SYNOPSIS
Indicates that a file contains text.

## SYNTAX

```
Test-TextFile.ps1 [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Test-TextFile.ps1 README.md
```

True

### EXAMPLE 2
```
Test-TextFile.ps1 avatar.jpg
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

### System.Boolean indicating that the file contains text.
## NOTES

## RELATED LINKS

[Test-FileTypeMagicNumber.ps1]()

