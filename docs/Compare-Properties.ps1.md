---
external help file: -help.xml
Module Name:
online version: https://docs.microsoft.com/dotnet/api/system.management.automation.psmemberset
schema: 2.0.0
---

# Compare-Properties.ps1

## SYNOPSIS
Compares the properties of two objects.

## SYNTAX

```
Compare-Properties.ps1 [[-ReferenceObject] <PSObject>] [[-DifferenceObject] <PSObject>] [-ExcludeDifferent]
 [-IncludeEqual] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Compare-Properties.ps1 (Get-PSProvider variable) (Get-PSProvider alias)
```

PropertyName   : ImplementingType
Reference      : True
Value          : Microsoft.PowerShell.Commands.VariableProvider
Difference     : True
DifferentValue : Microsoft.PowerShell.Commands.AliasProvider

PropertyName   : Name
Reference      : True
Value          : Variable
Difference     : True
DifferentValue : Alias

PropertyName   : Drives
Reference      : True
Value          : {Variable}
Difference     : True
DifferentValue : {Alias}

## PARAMETERS

### -ReferenceObject
The base object to compare properties to.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DifferenceObject
The second object to compare the properties of.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ExcludeDifferent
Indicates different values should be suppressed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeEqual
Indicates equal values should be included.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject with properties to compare.
## OUTPUTS

### System.Management.Automation.PSCustomObject for each relevant property comparison,
### with these fields:
### 	* PropertyName
### 	* Reference
### 	* Value
### 	* Difference
### 	* DifferentValue
## NOTES

## RELATED LINKS

[https://docs.microsoft.com/dotnet/api/system.management.automation.psmemberset](https://docs.microsoft.com/dotnet/api/system.management.automation.psmemberset)

