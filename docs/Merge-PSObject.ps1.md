---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Merge-PSObject.ps1

## SYNOPSIS
Create a new PSObject by recursively combining the properties of PSObjects.

## SYNTAX

```
Merge-PSObject.ps1 [[-ReferenceObject] <PSObject>] [-InputObject] <PSObject> [-Accumulate] [-Force]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Merge-PSObject.ps1 ([pscustomobject]@{a=1;b=2}) ([pscustomobject]@{b=0;c=3})
```

a b c
- - -
1 0 3

### EXAMPLE 2
```
'{"a":1,"b":{"u":3},"c":{"v":5}}','{"a":{"w":8},"b":2,"c":{"x":6}}' |ConvertFrom-Json |Merge-PSObject.ps1 -Force |ConvertTo-Json
```

{
	"a":  {
			"w":  8
		},
	"b":  2,
	"c":  {
			"v":  5,
			"x":  6
		}
}

## PARAMETERS

### -ReferenceObject
Initial PSObject to combine.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: [pscustomobject]@{}
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
PSObjects to combine.
PSObject descendant properties are recursively merged.
Primitive values are overwritten by any matching ones in the new PSObject.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Accumulate
{{ Fill Accumulate Description }}

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

### -Force
{{ Fill Force Description }}

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

### System.Management.Automation.PSObject to combine.
## OUTPUTS

### System.Management.Automation.PSObject combining the inputs.
## NOTES

## RELATED LINKS

[Get-Member]()

[Add-Member]()

