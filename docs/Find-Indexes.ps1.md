---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Find-Indexes.ps1

## SYNOPSIS
Returns indexes using a column with the given name.

## SYNTAX

### ByConnectionParameters
```
Find-Indexes.ps1 [-ServerInstance] <String> [-Database] <String> [-ColumnName] <String> [<CommonParameters>]
```

### ByConnectionString
```
Find-Indexes.ps1 -ConnectionString <String> [-ColumnName] <String> [<CommonParameters>]
```

### ByConnectionName
```
Find-Indexes.ps1 -ConnectionName <String> [-ColumnName] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Find-Indexes.ps1 -ServerInstance '(localdb)\ProjectsV13' -Database AdventureWorks2014 -ColumnName ErrorLogID
```

SchemaName     : dbo
TableName      : ErrorLog
IndexName      : PK_ErrorLog_ErrorLogID
IndexOrdinal   : 1
IsUnique       : 1
IsClustered    : 1
IsDisabled     : 0
ColumnsInIndex : 1

## PARAMETERS

### -ServerInstance
The name of a server (and optional instance) to connect and use for the query.
May be used with optional Database, Credential, and ConnectionProperties parameters.

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
The the database to connect to on the server.

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
The connection string name from the ConfigurationManager to use.

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

### -ColumnName
The column name to search for.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ColName

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject with these properties:
### 	* SchemaName
### 	* TableName
### 	* IndexName
### 	* IndexOrdinal
### 	* IsUnique
### 	* IsClustered
### 	* IsDisabled
### 	* ColumnsInIndex
## NOTES

## RELATED LINKS

[Invoke-Sqlcmd]()

[ConvertFrom-DataRow.ps1]()

[https://docs.microsoft.com/sql/relational-databases/system-catalog-views/sys-index-columns-transact-sql](https://docs.microsoft.com/sql/relational-databases/system-catalog-views/sys-index-columns-transact-sql)

