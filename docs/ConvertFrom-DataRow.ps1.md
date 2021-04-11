---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# ConvertFrom-DataRow.ps1

## SYNOPSIS
Converts a DataRow object to a PSObject, Hashtable, or single value.

## SYNTAX

### AsObject (Default)
```
ConvertFrom-DataRow.ps1 [-DataRow] <DataRow> [<CommonParameters>]
```

### AsValues
```
ConvertFrom-DataRow.ps1 [-DataRow] <DataRow> [-AsValues] [<CommonParameters>]
```

### AsDictionary
```
ConvertFrom-DataRow.ps1 [-DataRow] <DataRow> [-AsDictionary] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Invoke-Sqlcmd "select top 3 ProductID, Name from Production.Product" -ServerInstance ServerName -Database AdventureWorks |ConvertFrom-DataRow.ps1 |ConvertTo-Html
```

## PARAMETERS

### -DataRow
A record containing fields/columns to convert to an object with properties.

```yaml
Type: DataRow
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -AsValues
Indicates a the record's values should be returned as an array.

```yaml
Type: SwitchParameter
Parameter Sets: AsValues
Aliases: AsArray

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsDictionary
Indicates an ordered dictionary of fieldnames/columnnames to values should be returned
rather than an object with properties.

```yaml
Type: SwitchParameter
Parameter Sets: AsDictionary
Aliases: AsOrderedDictionary, AsHashtable

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Data.DataRow with fields to convert into an object with properties or
### into a hash with key/value pairs.
## OUTPUTS

### System.Management.Automation.PSObject
### or System.Object[] if -AsValues is specified
### or System.Collections.Specialized.OrderedDictionary if -AsDictionary is specified
## NOTES

## RELATED LINKS
