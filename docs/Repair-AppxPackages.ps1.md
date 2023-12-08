---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# Repair-AppxPackages.ps1

## SYNOPSIS
Re-registers all installed Appx packages.

## SYNTAX

```
Repair-AppxPackages.ps1 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Repair-AppxPackages.ps1
```

Repairs what Windows Store apps it can when run from PowerShell 5.1 (not in Windows Terminal) as admin.

## PARAMETERS

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
Must be run in Windows PowerShell, apparently.
Do not run in Windows Terminal.

## RELATED LINKS
