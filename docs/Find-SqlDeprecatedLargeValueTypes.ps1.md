---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Find-SqlDeprecatedLargeValueTypes.ps1

## SYNOPSIS
Reports text, ntext, and image datatypes found in a given database.

## SYNTAX

### ByConnectionParameters
```
Find-SqlDeprecatedLargeValueTypes.ps1 [-ServerInstance] <String> [-Database] <String> [<CommonParameters>]
```

### ByConnectionString
```
Find-SqlDeprecatedLargeValueTypes.ps1 -ConnectionString <String> [<CommonParameters>]
```

### ByConnectionName
```
Find-SqlDeprecatedLargeValueTypes.ps1 -ConnectionName <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Find-SqlDeprecatedLargeValueTypes.ps1 '(localdb)\ProjectsV13' pubs
```

Returns text, ntext, and image columns and scripts to convert them to
the new (n)var*(max) types.

## PARAMETERS

### -ServerInstance
A string specifying the name of an instance of the Database Engine.
For default instances, only specify the computer name: "MyComputer".
For named instances, use the format "ComputerName\InstanceName".

```yaml
Type: String
Parameter Sets: ByConnectionParameters
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Database
A string specifying the name of a database on the server specified
by the ServerInstance parameter.

```yaml
Type: String
Parameter Sets: ByConnectionParameters
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectionString
Specifies a connection string to connect to the server.

```yaml
Type: String
Parameter Sets: ByConnectionString
Aliases: ConnStr, CS

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectionName
The connection string name from the ConfigurationManager to use to
connect to the server.

```yaml
Type: String
Parameter Sets: ByConnectionName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Management.Automation.PSCustomObject each with an ObjectType property that
### indicates what other properties are available:
### Column
### * ObjectType: "Column"
### * ColumnName: The fully-qualified name of the column.
### * DataType: Which deprecated type the column currently is
### (text, ntext, or image).
### * ValuesCount: The number of rows in the table, including
### null values in the column.
### * RowsUnder8K: The new "(max)" large data types store values
### under 8K in size in-row, rather than externally, which is
### faster. This is a count of how many values can be stored
### in-row after conversion.
### * MinDataLength: The minimum data length of the field, in
### bytes, excluding nulls.
### * AvgDataLength: The median average data length of the field,
### in bytes, excluding nulls.
### * MaxDataLength: The maximum data length of the field, in
### bytes, excluding nulls.
### * Sigma1: The impact of reducing the maximum data length of
### the field to within one standard deviation of the mean.
### * Sigma2: The impact of reducing the maximum data length of
### the field to within two standard deviations of the mean.
### * Sigma3: The impact of reducing the maximum data length of
### the field to within three standard deviations of the mean.
### * Sigma4: The impact of reducing the maximum data length of
### the field to within four standard deviations of the mean.
### * Sigma5: The impact of reducing the maximum data length of
### the field to within five standard deviations of the mean.
### * Sigma6: The impact of reducing the maximum data length of
### the field to within six standard deviations of the mean.
### * Sigma7: The impact of reducing the maximum data length of
### the field to within seven standard deviations of the mean.
### * Sigma8: The impact of reducing the maximum data length of
### the field to within eight standard deviations of the mean.
### * IsUserTable: True when the column's table is a user table.
### False for tables in the "sys" schema, and other system tables.
### * IsMsShipped: True for tables created by Microsoft, such as
### dtproperties, false otherwise.
### * IsMsDbTools: True for tables created by Microsoft Tools,
### such as sysdiagrams, otherwise false.
### * ConvertSqlScript: The SQL script that can be used to convert
### the column from the deprecated large data type to the new
### "(max)" type.
### Parameter
### * TODO
### Routine
### * TODO
## NOTES

## RELATED LINKS

[Use-SqlcmdParams.ps1]()

[Invoke-Sqlcmd]()

