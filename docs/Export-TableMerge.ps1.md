---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Export-TableMerge.ps1

## SYNOPSIS
Exports table data as a T-SQL MERGE statement.

## SYNTAX

### ByConnectionParameters
```
Export-TableMerge.ps1 [-ServerInstance] <String> [-Database] <String> [-Table] <String> [[-Schema] <String>]
 [-UseIdentityInKey] [<CommonParameters>]
```

### ByConnectionString
```
Export-TableMerge.ps1 -ConnectionString <String> [-Table] <String> [[-Schema] <String>] [-UseIdentityInKey]
 [<CommonParameters>]
```

### ByConnectionName
```
Export-TableMerge.ps1 -ConnectionName <String> [-Table] <String> [[-Schema] <String>] [-UseIdentityInKey]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Export-TableMerge $server pubs employee |Out-File employee.sql
```

### EXAMPLE 2
```
Export-TableMerge -Server "(localdb)\ProjectV12" -Database AdventureWorks2014 -Schema Production -Table Product |Out-File Data\Production.Product.sql utf8
```

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

### -Table
The name of the table to export.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Schema
Optional name of the table's schema.
By default, uses the user's default schema defined in the database (typically dbo).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseIdentityInKey
{{ Fill UseIdentityInKey Description }}

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

### System.String of SQL MERGE script to replicate the table's data.
## NOTES

## RELATED LINKS

[Use-SqlcmdParams.ps1]()

[Invoke-Sqlcmd]()

[https://msdn.microsoft.com/library/hh245198.aspx](https://msdn.microsoft.com/library/hh245198.aspx)

