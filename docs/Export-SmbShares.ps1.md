---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Export-SmbShares.ps1

## SYNOPSIS
Export SMB shares using old NET SHARE command, to new New-SmbShare PowerShell commands.

## SYNTAX

```
Export-SmbShares.ps1 [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
This script is intended to be used to export shares from old machines to new ones.

## EXAMPLES

### EXAMPLE 1
```
Export-SmbShares.ps1
```

New-SmbShare -Name 'Data' -Path 'C:\Data' -ChangeAccess 'Everyone'

## PARAMETERS

### -Path
{{ Fill Path Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: "Import-${env:ComputerName}SmbShares.ps1"
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String[] of PowerShell commands to duplicate the local machine's shares.
## NOTES

## RELATED LINKS
