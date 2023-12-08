---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# Export-EdgeKeywords.ps1

## SYNOPSIS
Returns the configured search keywords from an Edge SQLite file.

## SYNTAX

```
Export-EdgeKeywords.ps1 [[-Path] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Export-EdgeKeywords.ps1 |ConvertTo-Json |Out-File ~/backup/msedge-keywords.json utf8
```

Backs up Edge search keywords as JSON to a file.

## PARAMETERS

### -Path
The path to the SQLite file containing the Edge keywords table to export.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: "$env:LocalAppData\Microsoft\Edge\User Data\Default\Web Data"
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

### System.Management.Automation.PSObject containing the search keyword details.
## NOTES

## RELATED LINKS
