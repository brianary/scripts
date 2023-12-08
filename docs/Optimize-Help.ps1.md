---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# Optimize-Help.ps1

## SYNOPSIS
Cleans up comment-based help blocks by fully unindenting and capitalizing dot keywords.

## SYNTAX

```
Optimize-Help.ps1 [-Path] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Optimize-Help.ps1 Get-Thing.ps1
```

Unindents help and capitalizes dot keywords in Get-Thing.ps1

## PARAMETERS

### -Path
The script to process.

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

### An object with a Path or FullName property.
## OUTPUTS

## NOTES

## RELATED LINKS
