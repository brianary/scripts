---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Measure-Indents.ps1

## SYNOPSIS
Measures the indentation characters used in a text file.

## SYNTAX

```
Measure-Indents.ps1 [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Measure-Indents.ps1 Program.cs
```

Tab Space Mix Other
--- ----- --- -----
  1    17   0     0

## PARAMETERS

### -Path
A file to measure.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String file path to examine.
## OUTPUTS

### System.Management.Automation.PSCustomObject with properties indictating indentation counts.
### * Tab: Lines starting with tabs.
### * Space: Lines starting with spaces.
### * Mix: Lines starting with both tabs and spaces.
### * Other: Lines starting with any other whitespace characters than tab or space.
## NOTES

## RELATED LINKS
