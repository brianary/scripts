---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Find-DuplicateFiles.ps1

## SYNOPSIS
Removes duplicates from a list of files.

## SYNTAX

```
Find-DuplicateFiles.ps1 [[-Files] <FileInfo[]>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-ChildItem -Recurse -File |Find-DuplicateFiles.ps1 |Remove-Item
```

Removes all but the oldest file with the same size and hash value.

## PARAMETERS

### -Files
A list of files to search for duplicates.

```yaml
Type: FileInfo[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.IO.FileInfo list, typically piped from Get-ChildItem.
## OUTPUTS

### System.String containing the full paths of the both matching files.
## NOTES

## RELATED LINKS
