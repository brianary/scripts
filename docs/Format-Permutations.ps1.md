---
external help file: -help.xml
Module Name:
online version: https://social.technet.microsoft.com/wiki/contents/articles/7855.powershell-using-the-f-format-operator.aspx
schema: 2.0.0
---

# Format-Permutations.ps1

## SYNOPSIS
Builds format strings using every combination of elements from multiple arrays.

## SYNTAX

```
Format-Permutations.ps1 [-Format] <String> [-InputObject] <Object[][]> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Format-Permutations.ps1 'srv-{0}-{1:00}' 'dev','test','stage','live' (1..4)
```

srv-dev-01
   srv-dev-02
   srv-dev-03
   srv-dev-04
   srv-test-01
   srv-test-02
   srv-test-03
   srv-test-04
   srv-stage-01
   srv-stage-02
   srv-stage-03
   srv-stage-04
   srv-live-01
   srv-live-02
   srv-live-03
   srv-live-04

## PARAMETERS

### -Format
A standard .NET format string as used with the PowerShell -f operator.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
A list of lists to put together in all combinations (a Cartesian cross-product) and
format with the supplied format string.

```yaml
Type: Object[][]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String list of all combinations
## NOTES

## RELATED LINKS

[https://social.technet.microsoft.com/wiki/contents/articles/7855.powershell-using-the-f-format-operator.aspx](https://social.technet.microsoft.com/wiki/contents/articles/7855.powershell-using-the-f-format-operator.aspx)

