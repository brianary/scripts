---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Remove-LockyFile.ps1

## SYNOPSIS
Removes a file that may be prone to locking.

## SYNTAX

```
Remove-LockyFile.ps1 [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Remove-LockyFile.ps1 InUse.dll
```

(Tries to remove file, renames it if unable to, tries deleting at reboot as a last resort.)

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

### System.String containing the path of a file to delete (or rename if deleting fails).
## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS
