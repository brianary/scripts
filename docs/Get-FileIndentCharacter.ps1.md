---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-FileIndentCharacter.ps1

## SYNOPSIS
Determines the indent characters used in a text file.

## SYNTAX

```
Get-FileIndentCharacter.ps1 [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-FileIndentCharacter.ps1 Get-FileIdentCharacter.ps1
```

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
### * Tabs if the file only contains HT indents.
### * Spaces if the file only contains PS indents.
### * Mixed (HT=n, SP=m, other/combined=k) if the file contains multiple different indents.
### * None if the file contains no indents.
## NOTES

## RELATED LINKS

[Select-String]()

