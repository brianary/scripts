---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Test-LockedFile.ps1

## SYNOPSIS
Returns true if the specified file is locked.

## SYNTAX

```
Test-LockedFile.ps1 [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Path
A path to a file to test.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Object with System.String property named Path containing the path to a file to test.
## OUTPUTS

### System.Boolean indicating whether the file is locked.
## NOTES

## RELATED LINKS
