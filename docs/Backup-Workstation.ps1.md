---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Backup-Workstation.ps1

## SYNOPSIS
Adds various configuration files and exported settings to a ZIP file.

## SYNTAX

```
Backup-Workstation.ps1 [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Backup-Workstation.ps1
```

Saves various config data to COMPUTERNAME-20230304T125000.zip.

## PARAMETERS

### -Path
{{ Fill Path Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (Join-Path ~ ('{0}-{1:yyyyMMdd\THHmmss}.zip' -f $env:COMPUTERNAME,(Get-Date)))
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Export-InstalledPackages.ps1]()

[Export-EdgeKeywords.ps1]()

[Export-SecretVault.ps1]()

