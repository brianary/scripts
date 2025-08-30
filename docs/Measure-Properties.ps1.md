---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Measure-Properties.ps1

## SYNOPSIS
Provides frequency details about the properties across objects in the pipeline.

## SYNTAX

```
Measure-Properties.ps1 [[-InputObject] <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-PSDrive |Measure-Properties.ps1 |Format-Table -AutoSize
```

Type: System.Management.Automation.PSDriveInfo
Count: 13

PropertyName           Type           Unique Nulls Values         Minimum                   Maximum
------------           ----           ------ ----- ------         -------                   -------
Used                   System.Object   False    12      1 219129761792.00           219129761792.00
Free                   System.Object   False    12      1 803764846592.00           803764846592.00
CurrentLocation        System.String   False    11      2                               Users\brian
Name                   System.String    True     0     13               A                     WSMan
Root                   System.String   False     4      9               \               SQLSERVER:\
Description            System.String   False     1     12                 X509 Certificate Provider
VolumeSeparatedByColon System.Boolean  False    12      1            1.00                      1.00

## PARAMETERS

### -InputObject
{{ Fill InputObject Description }}

```yaml
Type: Object
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

### System.Object values to be analyzed in aggregate.
## OUTPUTS

### System.Management.Automation.PSCustomObject that describes the properties of the objects:
### * PropertyName
### * Type
### * Unique
### * Nulls
### * Values
### * Minimum
### * Maximum
## NOTES

## RELATED LINKS

[Write-Info.ps1]()

[Stop-ThrowError.ps1]()

