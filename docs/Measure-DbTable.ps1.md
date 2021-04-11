---
external help file: -help.xml
Module Name:
online version: https://www.powershellgallery.com/packages/SqlServer/
schema: 2.0.0
---

# Measure-DbTable.ps1

## SYNOPSIS
Provides frequency details about SQL Server table data.

## SYNTAX

```
Measure-DbTable.ps1 [-Table] <Table> [-Condition <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-DbaDbTable -sqli '(localdb)\ProjectsV13' -dat AdventureWorks2016 -tab Production.Product |Measure-DbTable.ps1
```

#TableName            : \[Production\].\[Product\]
#RowCount             : 504
ProductID             : unique, 0 nulls, 504 values: 1 ..
999
Name                  : unique, 0 nulls, 504 values: Adjustable Race ..
Women's Tights, S
ProductNumber         : unique, 0 nulls, 504 values: AR-5381 ..
WB-H098
MakeFlag              : bit: 0 nulls, 239 ones, 265 zeros
FinishedGoodsFlag     : bit: 0 nulls, 295 ones, 209 zeros
Color                 : 248 nulls, 9 values: Black ..
Yellow
SafetyStockLevel      : 0 nulls, 6 values: 4 ..
1000
ReorderPoint          : 0 nulls, 6 values: 3 ..
750
StandardCost          : 0 nulls, 114 values: 0.00 ..
2171.29
ListPrice             : 0 nulls, 103 values: 0.00 ..
3578.27
Size                  : 293 nulls, 18 values: 38 ..
XL
SizeUnitMeasureCode   : CM
WeightUnitMeasureCode : 299 nulls, 2 values: G   ..
LB
Weight                : 299 nulls, 127 values: 2.12 ..
1050.00
DaysToManufacture     : 0 nulls, 4 values: 0 ..
4
ProductLine           : 226 nulls, 4 values: M  ..
T
Class                 : 257 nulls, 3 values: H  ..
M
Style                 : 293 nulls, 3 values: M  ..
W
ProductSubcategoryID  : 209 nulls, 37 values: 1 ..
37
ProductModelID        : 209 nulls, 119 values: 1 ..
128
SellStartDate         : 0 nulls, 4 values: Apr 30 2008 12:00AM ..
May 30 2013 12:00AM
SellEndDate           : 406 nulls, 2 values: May 29 2012 12:00AM ..
May 29 2013 12:00AM
DiscontinuedDate      : null
rowguid               : unique, 0 nulls, 504 values: 7A927632-99A4-4F24-ADCE-0062D2D113D9 ..
B9EDE243-A6F4-4629-B1D4-FFE1AEDC6DE7
ModifiedDate          : 0 nulls, 2 values: Feb  8 2014 10:01AM ..
Feb  8 2014 10:03AM

## PARAMETERS

### -Table
An SMO table object associated to the database to examine.

```yaml
Type: Table
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Condition
Conditions to be provided as a SQL WHERE clause to filter the record values to examine.
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.SqlServer.Management.Smo.Table to analyze.
## OUTPUTS

### System.Management.Automation.PSCustomObject that describes each table column.
## NOTES

## RELATED LINKS

[https://www.powershellgallery.com/packages/SqlServer/](https://www.powershellgallery.com/packages/SqlServer/)

[https://dbatools.io/](https://dbatools.io/)

