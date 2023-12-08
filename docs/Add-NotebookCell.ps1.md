---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# Add-NotebookCell.ps1

## SYNOPSIS
When run within a Polyglot Notebook, appends a cell to it.

## SYNTAX

```
Add-NotebookCell.ps1 [-InputObject] <PSObject> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
B" |Add-NotebookCell.ps1 mermaid
```

Appends a cell with a Mermaid chart.

## PARAMETERS

### -InputObject
The cell content.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Any object that can be converted to a string and used as cell content.
## OUTPUTS

## NOTES

## RELATED LINKS
