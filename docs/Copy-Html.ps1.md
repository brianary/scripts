---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Copy-Html.ps1

## SYNOPSIS
Copies objects as an HTML table.

## SYNTAX

```
Copy-Html.ps1 [[-Property] <Array>] [-InputObject <PSObject>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-PSDrive |Copy-Html.ps1 Name,Description
```

Copies an HTML table with two columns to the clipboard as formatted text
that can be pasted into emails or other formatted documents.

## PARAMETERS

### -Property
Columns to include in the copied table.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
The objects to turn into table rows.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

### System.Management.Automation.PSObject to be turned into a table row.
## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[Format-HtmlDataTable.ps1]()

[ConvertTo-SafeEntities.ps1]()

[Invoke-WindowsPowerShell.ps1]()

