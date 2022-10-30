---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Measure-TextFile.ps1

## SYNOPSIS
Counts each type of indent and line ending.

## SYNTAX

```
Measure-TextFile.ps1 [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Measure-TextFile.ps1 .\Measure-TextFile.ps1
```

Path         : A:\scripts\Measure-TextFile.ps1
Encoding     : Unicode (UTF-8)
Lines        : 88
LineEndings  : CRLF
Indentation  : Tabs
IndentSize   : 1
FinalNewline : True

## PARAMETERS

### -Path
A file to examine.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String containing a filename to examine.
## OUTPUTS

### System.Management.Automation.PSCustomObject containing these properties:
### * Path: The original file path.
### * Encoding: The name of the file encoding.
### * Lines: The number of lines in the text file.
### * LineEndings: CRLF, CR, and/or LF
### * Indentation: Tabs, Spaces, or Mixed (with proportions).
### * IndentSize: Number of spaces per indent (or 1 for Tabs).
### * FinalNewline: A boolean indicating whether the file properly ends with an end-of-line.
## NOTES

## RELATED LINKS
