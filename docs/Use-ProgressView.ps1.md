---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Use-ProgressView.ps1

## SYNOPSIS
Sets the progress bar display view.

## SYNTAX

```
Use-ProgressView.ps1 [-View] <ProgressView> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Use-ProgressView.ps1 Classic
```

Restores the Windows PowerShell 5.x-style top progress banner for Write-Progress.

## PARAMETERS

### -View
The progress view to use.

```yaml
Type: ProgressView
Parameter Sets: (All)
Aliases:
Accepted values: Minimal, Classic

Required: True
Position: 1
Default value: None
Accept pipeline input: False
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

## OUTPUTS

## NOTES

## RELATED LINKS

[about_ANSI_Terminals]()

