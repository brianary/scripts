---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Add-Counter.ps1

## SYNOPSIS
Adds a incrementing integer property to each pipeline object.

## SYNTAX

```
Add-Counter.ps1 [[-PropertyName] <String>] [[-InitialValue] <Int32>] -InputObject <PSObject>
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-PSProvider |Add-Counter Position |select Position,Name
```

Position Name
-------- ----
       1 Registry
       2 Alias
       3 Environment
       4 FileSystem
       5 Function
       6 Variable
       7 Certificate

## PARAMETERS

### -PropertyName
The name of the property to add.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Counter
Accept pipeline input: False
Accept wildcard characters: False
```

### -InitialValue
The starting number to count from.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
The object to add the property to.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject
## NOTES

## RELATED LINKS

[Add-Member]()

