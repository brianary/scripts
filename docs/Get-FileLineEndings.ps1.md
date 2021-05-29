---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-FileLineEndings.ps1

## SYNOPSIS
Determines a file's line endings.

## SYNTAX

```
Get-FileLineEndings.ps1 [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-FileLineEndings.ps1 info.txt
```

CRLF

## PARAMETERS

### -Path
The location of a file.

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

### Any object with a Path or FullName property to use for a file location.
## OUTPUTS

### System.String containing:
### * CRLF if the file only contains CRLF line endings
### * LF if the file only contains LF line endings.
### * CR if the file only contains CR line endings.
### * Mixed (CRLF=n, LF=m, CR=k) if the file contains different line endings.
### * None if the file contains no line endings.
## NOTES

## RELATED LINKS

[Get-Content]()

