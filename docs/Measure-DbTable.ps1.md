---
external help file: -help.xml
Module Name:
online version: https://www.powershellgallery.com/packages/SqlServer/
schema: 2.0.0
---

# Measure-DbColumnValues.ps1

## SYNOPSIS
Provides sorted counts of SQL Server column values.

## SYNTAX

### Column
```
Measure-DbColumnValues.ps1 [-Column] <Column> [-Condition <String>] [-MinimumCount <Int32>]
 [<CommonParameters>]
```

### ColumnName
```
Measure-DbColumnValues.ps1 [-ColumnName] <String> [-Table] <Table> [-Condition <String>]
 [-MinimumCount <Int32>] [<CommonParameters>]
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

### -Column
An SMO column object associated to the database column to examine.

```yaml
Type: Column
Parameter Sets: Column
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ColumnName
The name of the column to examine in the table associated with the SMO Table object.

```yaml
Type: String
Parameter Sets: ColumnName
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Table
An SMO table object associated to the database to examine.

```yaml
Type: Table
Parameter Sets: ColumnName
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Condition
Conditions to be provided as a SQL WHERE clause to filter the column values to examine.
Useful for databases that implement "soft deletes" as specific field values.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinimumCount
Excludes values with fewer than this number of occurrences.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.SqlServer.Management.Smo.Column to calculate statistics for,
### or Microsoft.SqlServer.Management.Smo.Table to select a column from by name.
## OUTPUTS

### System.Management.Automation.PSCustomObject that describes each counted value.
## NOTES

## RELATED LINKS

[https://www.powershellgallery.com/packages/SqlServer/](https://www.powershellgallery.com/packages/SqlServer/)

[https://dbatools.io/](https://dbatools.io/)

