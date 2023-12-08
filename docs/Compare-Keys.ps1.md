---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Compare-Keys.ps1

## SYNOPSIS
Returns the differences between two dictionaries.

## SYNTAX

```
Compare-Keys.ps1 [-ReferenceDictionary] <IDictionary> [-DifferenceDictionary] <IDictionary> [-ExcludeDifferent]
 [-IncludeEqual] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Compare-Keys.ps1 @{ A = 1; B = 2; C = 3 } @{ D = 6; C = 4; B = 2 } -IncludeEqual
```

Key    Action ReferenceValue DifferenceValue
---    ------ -------------- ---------------
A     Deleted              1
B   Unchanged              2 2
C    Modified              3 4
D       Added                6

## PARAMETERS

### -ReferenceDictionary
The original dictionary to compare.

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DifferenceDictionary
A dictionary to compare to the original.

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ExcludeDifferent
Indicates that different values should be ignored.

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
Indicates that identical values should be included.

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

### System.Collections.IDictionary to compare to the reference dictionary.
## OUTPUTS

### System.Management.Automation.PSObject with these properties:
### * Key: The dictionary key being compared.
### * Action: A Data.DataRowState that indicates whether the key-value pair has been
### Added, Deleted, Modified, or Unchanged.
### * ReferenceValue: The original value.
### * DifferenceValue: The new value.
## NOTES

## RELATED LINKS

[Compare-Object]()

[Group-Object]()

[ForEach-Object]()

[Sort-Object]()

