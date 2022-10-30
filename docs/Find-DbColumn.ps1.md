---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Find-DbColumn.ps1

## SYNOPSIS
Searches for database columns.

## SYNTAX

### ByConnectionParameters
```
Find-DbColumn.ps1 -ServerInstance <String> -Database <String> [-IncludeSchemata <String[]>]
 [-ExcludeSchemata <String[]>] [-IncludeTables <String[]>] [-ExcludeTables <String[]>]
 [-IncludeColumns <String[]>] [-ExcludeColumns <String[]>] [-DataType <String>] [-MinLength <Int32>]
 [-MaxLength <Int32>] [<CommonParameters>]
```

### ByConnectionString
```
Find-DbColumn.ps1 -ConnectionString <String> [-IncludeSchemata <String[]>] [-ExcludeSchemata <String[]>]
 [-IncludeTables <String[]>] [-ExcludeTables <String[]>] [-IncludeColumns <String[]>]
 [-ExcludeColumns <String[]>] [-DataType <String>] [-MinLength <Int32>] [-MaxLength <Int32>]
 [<CommonParameters>]
```

### ByConnectionName
```
Find-DbColumn.ps1 -ConnectionName <String> [-IncludeSchemata <String[]>] [-ExcludeSchemata <String[]>]
 [-IncludeTables <String[]>] [-ExcludeTables <String[]>] [-IncludeColumns <String[]>]
 [-ExcludeColumns <String[]>] [-DataType <String>] [-MinLength <Int32>] [-MaxLength <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Find-DbColumn.ps1 -ServerInstance '(localdb)\ProjectsV13' -Database AdventureWorks2016 -IncludeColumns %price% |Format-Table -AutoSize
```

TableSchema TableName               ColumnName        DataType Nullable DefaultValue
----------- ---------               ----------        -------- -------- ------------
Production  Product                 ListPrice         money       False
Production  ProductListPriceHistory ListPrice         money       False
Purchasing  ProductVendor           StandardPrice     money       False
Purchasing  PurchaseOrderDetail     UnitPrice         money       False
Sales       SalesOrderDetail        UnitPrice         money       False
Sales       SalesOrderDetail        UnitPriceDiscount money       False ((0.0))

## PARAMETERS

### -ServerInstance
The server and instance to connect to.

```yaml
Type: String
Parameter Sets: ByConnectionParameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Database
The database to use.

```yaml
Type: String
Parameter Sets: ByConnectionParameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectionString
{{ Fill ConnectionString Description }}

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
{{ Fill ConnectionName Description }}

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

### -IncludeSchemata
A like-pattern of database schemata to include (will only include these).

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeSchemata
A like-pattern of database schemata to exclude.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeTables
A like-pattern of database tables to include (will only include these).

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeTables
A like-pattern of database tables to exclude.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeColumns
A like-pattern of database columns to include (will only include these).

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeColumns
A like-pattern of database columns to exclude.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataType
The basic datatype to search for.

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

### -MinLength
The minimum character column length.

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

### -MaxLength
The maximum character column length.

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

## OUTPUTS

### System.Management.Automation.PSCustomObject for each found column:
### * TableSchema
### * TableName
### * ColumnName
### * DataType
### * Nullable
### * DefaultValue
## NOTES

## RELATED LINKS

[ConvertFrom-DataRow.ps1]()

[Stop-ThrowError.ps1]()

[Invoke-Sqlcmd]()

