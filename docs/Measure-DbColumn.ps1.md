---
external help file: -help.xml
Module Name:
online version: https://www.powershellgallery.com/packages/SqlServer/
schema: 2.0.0
---

# Measure-DbColumn.ps1

## SYNOPSIS
Provides statistics about SQL Server column data.

## SYNTAX

### Column
```
Measure-DbColumn.ps1 [-Column] <Column> [-Condition <String>] [<CommonParameters>]
```

### ColumnName
```
Measure-DbColumn.ps1 [-ColumnName] <String> [-Table] <Table> [-Condition <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
$table = Get-DbaDbTable SqlServerName -Database DbName -Table TableName; Measure-DbColumn.ps1 $table.Columns['record_id']
```

ColumnName        : record_id
SqlType           : int
NullValues        : 0
IsUnique          : True
UniqueValues      : 43
MinimumValue      : 2
MaximumValue      : 56
MeanAverage       : 28
ModeAverage       : 28
Variance          : 290.330011074197
StandardDeviation : 17.0390730696889

### EXAMPLE 2
```
Get-DbaDbTable SqlServerName -Database DbName -Table TableName |Measure-DbColumn.ps1 surname
```

ColumnName         : surname
SqlType            : varchar(40)
NullValues         : 0
IsUnique           : False
UniqueValues       : 72281
MinimumValue       :  AARONSON
MaximumValue       : ZYKOWSKI
MostCommonValue    : SMITH
MininumLength      : 1
MaximumLength      : 40
HasLeadingSpaces   : True
HasTrailingSpaces  : False
HasControlChars    : False
HasWindows1252     : False
HasUnicode         : False
HasNonAscii7       : False
HasNonAlphanumeric : True

### EXAMPLE 3
```
Get-DbaDbTable '(localdb)\ProjectsV13' -database AdventureWorks2016 -Table Sales.SalesOrderHeader |Measure-DbColumn.ps1 OrderDate
```

ColumnName      : OrderDate
SqlType         : datetime
Values          : 31465
NullValues      : 0
IsUnique        : False
IsDateOnly      : True
DateOnlyValues  : 31465
DateTimeValues  : 0
UniqueValues    : 1124
MostCommonValue : 03/31/2014 00:00:00
MinimumValue    : 05/31/2011 00:00:00
MaximumValue    : 06/30/2014 00:00:00
ModeAverage     : 03/31/2014 00:00:00
MeanYear        : 2013
ModeYear        : 2013
MeanMonth       : January
ModeMonth       : May
MeanDayOfWeek   : Thursday
ModeDayOfWeek   : Monday
MeanDayOfMonth  : 16
Sunday          : 4444
Monday          : 4875
Tuesday         : 4482
Wednesday       : 4591
Thursday        : 4346
Friday          : 4244
Saturday        : 4483
January         : 2877
Febuary         : 2300
March           : 3144
April           : 2812
May             : 3175
June            : 2189
July            : 2356
August          : 2324
September       : 2300
October         : 2616
November        : 2716
December        : 2656

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.SqlServer.Management.Smo.Column to calculate statistics for,
### or Microsoft.SqlServer.Management.Smo.Table to select a column from by name.
## OUTPUTS

### System.Management.Automation.PSCustomObject that describes the column:
### 	* ColumnName
### 	* SqlType
### 	* NullValues
### 	* IsUnique
### 	* UniqueValues
### 	* MinimumValue
### 	* MaximumValue
### 	* MeanAverage
### 	* ModeAverage
### 	* Variance
### 	* StandardDeviation
### 	* additonal properties, depending on type
## NOTES

## RELATED LINKS

[https://www.powershellgallery.com/packages/SqlServer/](https://www.powershellgallery.com/packages/SqlServer/)

[https://dbatools.io/](https://dbatools.io/)

[https://wikipedia.org/wiki/Windows1252](https://wikipedia.org/wiki/Windows1252)

