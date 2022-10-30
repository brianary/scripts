---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Find-DatabaseValue.ps1

## SYNOPSIS
Searches an entire database for a field value.

## SYNTAX

### ByConnectionParameters
```
Find-DatabaseValue.ps1 [-Value] <Object> -ServerInstance <String> -Database <String>
 [-IncludeSchemata <String[]>] [-ExcludeSchemata <String[]>] [-IncludeTables <String[]>]
 [-ExcludeTables <String[]>] [-IncludeColumns <String[]>] [-ExcludeColumns <String[]>] [-MinRows <Int32>]
 [-MaxRows <Int32>] [-FindFirst] [-LikeValue] [<CommonParameters>]
```

### ByConnectionString
```
Find-DatabaseValue.ps1 [-Value] <Object> -ConnectionString <String> [-IncludeSchemata <String[]>]
 [-ExcludeSchemata <String[]>] [-IncludeTables <String[]>] [-ExcludeTables <String[]>]
 [-IncludeColumns <String[]>] [-ExcludeColumns <String[]>] [-MinRows <Int32>] [-MaxRows <Int32>] [-FindFirst]
 [-LikeValue] [<CommonParameters>]
```

### ByConnectionName
```
Find-DatabaseValue.ps1 [-Value] <Object> -ConnectionName <String> [-IncludeSchemata <String[]>]
 [-ExcludeSchemata <String[]>] [-IncludeTables <String[]>] [-ExcludeTables <String[]>]
 [-IncludeColumns <String[]>] [-ExcludeColumns <String[]>] [-MinRows <Int32>] [-MaxRows <Int32>] [-FindFirst]
 [-LikeValue] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Find-DatabaseValue.ps1 FR -IncludeSchemata Sales -MaxRows 100 -ServerInstance '(localdb)\ProjectsV13' -Database AdventureWorks2016
```

TableName         : \[Sales\].\[SalesTerritory\]
TerritoryID       : 7
Name              : France
CountryRegionCode : FR
Group             : Europe
SalesYTD          : 4772398.3078
SalesLastYear     : 2396539.7601
CostYTD           : 0.0000
CostLastYear      : 0.0000
rowguid           : bf806804-9b4c-4b07-9d19-706f2e689552
ModifiedDate      : 04/30/2008 00:00:00

### EXAMPLE 2
```
Find-DatabaseValue.ps1 41636 -IncludeColumns %OrderID -ServerInstance '(localdb)\ProjectsV13' -Database AdventureWorks2016 |tee order41636.txt
```

TableName            : \[Production\].\[TransactionHistory\]
TransactionID        : 100046
ProductID            : 826
ReferenceOrderID     : 41636
ReferenceOrderLineID : 0
TransactionDate      : 07/31/2013 00:00:00
TransactionType      : W
Quantity             : 4
ActualCost           : 0.0000
ModifiedDate         : 07/31/2013 00:00:00

TableName     : \[Production\].\[WorkOrder\]
WorkOrderID   : 41636
ProductID     : 826
OrderQty      : 4
StockedQty    : 4
ScrappedQty   : 0
StartDate     : 07/31/2013 00:00:00
EndDate       : 08/11/2013 00:00:00
DueDate       : 08/11/2013 00:00:00
ScrapReasonID :
ModifiedDate  : 08/11/2013 00:00:00

TableName          : \[Production\].\[WorkOrderRouting\]
WorkOrderID        : 41636
ProductID          : 826
OperationSequence  : 6
LocationID         : 50
ScheduledStartDate : 07/31/2013 00:00:00
ScheduledEndDate   : 08/11/2013 00:00:00
ActualStartDate    : 08/01/2013 00:00:00
ActualEndDate      : 08/11/2013 00:00:00
ActualResourceHrs  : 3.0000
PlannedCost        : 36.7500
ActualCost         : 36.7500
ModifiedDate       : 08/11/2013 00:00:00

## PARAMETERS

### -Value
The value to search for.
The datatype is significant, e.g.
searching for money/smallmoney columns, cast the type to decimal: \[decimal\]13.55
Searches, by type:

    * string: varchar, char, nvarchar, nchar (char length must be at least as long as value)
    * byte: tinyint
    * int: bigint, int
    * long: bigint, numeric or decimal (where scale is zero)
    * decimal: money, smallmoney
    * double or float: float, real, numeric, decimal
    * datetime: date (if no time specified), datetime, datetime2, datetimeoffset, smalldatetime
* timespan: time

If the -LikeValue switch is specified, the type of value is assumed to be string.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -MinRows
Tables with more rows than this value will be skipped.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxRows
Tables with more rows than this value will be skipped.

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

### -FindFirst
Quit as soon as the first value is found.

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

### -LikeValue
Interpret the value as a like-pattern (% for zero-or-more characters, _ for a single character, \ is escape).

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

## OUTPUTS

### System.Management.Automation.PSCustomObject for each found row, including the #TableName,
### #ColumnName, and all fields.
## NOTES

## RELATED LINKS

[ConvertFrom-DataRow.ps1]()

[Stop-ThrowError.ps1]()

[Invoke-Sqlcmd]()

