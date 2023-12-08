---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Find-InstalledPrograms.ps1

## SYNOPSIS
Searches installed programs.

## SYNTAX

```
Find-InstalledPrograms.ps1 [[-Name] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Find-InstalledPrograms.ps1 %powershell%
```

IdentifyingNumber : {65276649-728D-4AB9-AAEC-6EFF860B11EC}
Name              : PowerShell 6-x64
Vendor            : Microsoft Corporation
Version           : 6.1.2.0
Caption           : PowerShell 6-x64

## PARAMETERS

### -Name
The product name to search for.
SQL-style "like" wildcards are supported.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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

### System.Management.ManagementObject for each program found.
## NOTES

## RELATED LINKS

[Get-WmiObject]()

[https://serverfault.com/questions/693264/with-powershell-get-exactly-the-same-application-list-as-in-add-remove-programms](https://serverfault.com/questions/693264/with-powershell-get-exactly-the-same-application-list-as-in-add-remove-programms)

