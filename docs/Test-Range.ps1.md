---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# Test-Range.ps1

## SYNOPSIS
Returns true from an initial condition until a terminating condition; a latching test.

## SYNTAX

```
Test-Range.ps1 [-After] <ScriptBlock> [-Before] <ScriptBlock> -InputObject <Object> [-Filter]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-Item *.ps1 |Test-Range.ps1 {$_.Name -like 'Join-*.ps1'} {$_.Name -like 'New-*.ps1'} -Filter |select Name
```

Name
----
Join-FileName.ps1
Measure-DbColumn.ps1
Measure-DbColumnValues.ps1
Measure-DbTable.ps1
Measure-Indents.ps1
Measure-StandardDeviation.ps1
Measure-TextFile.ps1
Merge-Dictionary.ps1
Merge-Json.ps1
Merge-PSObject.ps1
Merge-XmlSelections.ps1

## PARAMETERS

### -After
Latch: The initial condition which will begin the matching range.
Inclusive: Includes the input object that this condition evaluates a true value for.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Before
Unlatch: The terminating condition for the matching range.
Exclusive: Excludes the input object that this condition evaluates a true value for.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
{{ Fill InputObject Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Filter
{{ Fill Filter Description }}

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

### Any object to test.
## OUTPUTS

### System.Boolean, or the input object if -Filter is specified.
## NOTES

## RELATED LINKS
