---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Convert-ExternalScriptToModule.ps1

## SYNOPSIS
Convert a script from external script usage to module cmdlet usage.

## SYNTAX

```
Convert-ExternalScriptToModule.ps1 [[-ModuleName] <String>] [[-Path] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
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

### -ModuleName
The module to use instead of external scripts.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: ModernConveniences
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The script to update to module usage.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: False
Position: 2
Default value: *.ps1
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

### System.String containing the path of the script to update.
## OUTPUTS

## NOTES

## RELATED LINKS
