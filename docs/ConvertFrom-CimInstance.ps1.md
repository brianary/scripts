---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# ConvertFrom-CimInstance.ps1

## SYNOPSIS
Convert a CimInstance object to a PSObject.

## SYNTAX

```
ConvertFrom-CimInstance.ps1 [[-InputObject] <CimInstance>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
$tasks = Get-ScheduledTask |ConvertFrom-CimInstance.ps1
```

Gets the scheduled tasks as PSObjects that support tab completion and can be serialized and exported.

## PARAMETERS

### -InputObject
The CimInstance object to convert to a PSObject.

```yaml
Type: CimInstance
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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

### Microsoft.Management.Infrastructure.CimInstance to convert to a PSObject.
## OUTPUTS

### PSObject converted from the CimInstance entered.
## NOTES

## RELATED LINKS
