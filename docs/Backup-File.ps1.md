---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Backup-File.ps1

## SYNOPSIS
Create a backup as a sibling to a file, with date and time values in the name.

## SYNTAX

```
Backup-File.ps1 [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Backup-File.ps1 logfile.log
```

Copies logfile.log to logfile-201612311159.log (on that date & time).

## PARAMETERS

### -Path
Specifies a path to the items being removed.
Wildcards are permitted.
The parameter name ("-Path") is optional.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String, a file path to back up.
## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS
