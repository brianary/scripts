---
external help file: -help.xml
Module Name:
online version: https://msdn.microsoft.com/library/microsoft.sqlserver.management.smo.aspx
schema: 2.0.0
---

# Export-DatabaseObjectScript.ps1

## SYNOPSIS
Exports MS SQL script for an object from the given server.

## SYNTAX

### Urn
```
Export-DatabaseObjectScript.ps1 [-Server] <String> [-Database] <String> -Urn <String> [-Schema <String>]
 -FilePath <String> [-Encoding <String>] [-Append] [-ScriptingOptions <String[]>]
 [-SqlVersion <SqlServerVersion>] [<CommonParameters>]
```

### Table
```
Export-DatabaseObjectScript.ps1 [-Server] <String> [-Database] <String> -Table <String> [-Schema <String>]
 -FilePath <String> [-Encoding <String>] [-Append] [-ScriptingOptions <String[]>]
 [-SqlVersion <SqlServerVersion>] [<CommonParameters>]
```

### View
```
Export-DatabaseObjectScript.ps1 [-Server] <String> [-Database] <String> -View <String> [-Schema <String>]
 -FilePath <String> [-Encoding <String>] [-Append] [-ScriptingOptions <String[]>]
 [-SqlVersion <SqlServerVersion>] [<CommonParameters>]
```

### StoredProcedure
```
Export-DatabaseObjectScript.ps1 [-Server] <String> [-Database] <String> -StoredProcedure <String>
 [-Schema <String>] -FilePath <String> [-Encoding <String>] [-Append] [-ScriptingOptions <String[]>]
 [-SqlVersion <SqlServerVersion>] [<CommonParameters>]
```

### UserDefinedFunction
```
Export-DatabaseObjectScript.ps1 [-Server] <String> [-Database] <String> -UserDefinedFunction <String>
 [-Schema <String>] -FilePath <String> [-Encoding <String>] [-Append] [-ScriptingOptions <String[]>]
 [-SqlVersion <SqlServerVersion>] [<CommonParameters>]
```

## DESCRIPTION
This allows exporting a single database object to a SQL script, rather than
a whole database as Export-DatabaseScripts.ps1 does.

It can be particularly useful for creating an object-drop script, with all dependencies.

## EXAMPLES

### EXAMPLE 1
```
Export-DatabaseObjectScript.ps1 ServerName\instance AdventureWorks2014 -Table Customer -Schema Sales -FilePath Sales.Customer.sql
Exports table creation script to Sales.Customer.sql as UTF8.
```

### EXAMPLE 2
```
Export-DatabaseObjectScript.ps1 ServerName\instance AdventureWorks2014 -Table Customer -Schema Sales -FilePath DropCustomer.sql ScriptDrops WithDependencies SchemaQualify IncludeDatabaseContext
Exports drop script of Sales.Customer and dependencies to DropCustomer.sql.
```

## PARAMETERS

### -Server
The name of the server (and instance) to connect to.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ServerInstance

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Database
The name of the database to connect to on the server.

```yaml
Type: String
Parameter Sets: (All)
Aliases: TABLE_CATALOG, ROUTINE_CATALOG

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Urn
The Urn of the database object to script.
Example: "Server\[@Name='ServerName\Instance'\]/Database\[@Name='DatabaseName'\]/Table\[@Name='TableName' and @Schema='dbo'\]"

```yaml
Type: String
Parameter Sets: Urn
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Table
The unquoted name of the table to script.
Resolved using the Schema parameter.

```yaml
Type: String
Parameter Sets: Table
Aliases: TABLE_NAME

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -View
The unquoted name of the view to script.
Resolved using the Schema parameter.

```yaml
Type: String
Parameter Sets: View
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StoredProcedure
The unquoted name of the stored procedure to script.
Resolved using the Schema parameter.

```yaml
Type: String
Parameter Sets: StoredProcedure
Aliases: ROUTINE_NAME, Procedure, SProcedure

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -UserDefinedFunction
The unquoted name of the user defined function to script.
Resolved using the Schema parameter.

```yaml
Type: String
Parameter Sets: UserDefinedFunction
Aliases: UDF, Function

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Schema
The unquoted name of the schema to use with the Table, View, StoredProcedure, or UserDefinedFunction parameters.
Defaults to dbo.

```yaml
Type: String
Parameter Sets: (All)
Aliases: TABLE_SCHEMA, ROUTINE_SCHEMA

Required: False
Position: Named
Default value: Dbo
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -FilePath
The file to export the script to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Encoding
The file encoding to use for the SQL scripts.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: UTF8
Accept pipeline input: False
Accept wildcard characters: False
```

### -Append
Indicates the file should be appended to, rather than replaced.
Useful when piping a list of objects to be scripted to a file.

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

### -ScriptingOptions
Provides a list of boolean SMO ScriptingOptions properties to set to true.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 'EnforceScriptingOptions ExtendedProperties Permissions DriAll Indexes Triggers ScriptBatchTerminator' -split '\s+'
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlVersion
The SQL version to target when scripting.
By default, uses the version from the source server.
Versions greater than the source server's version may fail.

```yaml
Type: SqlServerVersion
Parameter Sets: (All)
Aliases:
Accepted values: Version80, Version90, Version100, Version105, Version110, Version120, Version130, Version140, Version150

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Data.DataRow, INFORMATION_SCHEMA.TABLES or INFORMATION_SCHEMA.ROUTINES records.
## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[Export-DatabaseScripts.ps1]()

[Install-SqlServerModule.ps1]()

[https://msdn.microsoft.com/library/microsoft.sqlserver.management.smo.aspx](https://msdn.microsoft.com/library/microsoft.sqlserver.management.smo.aspx)

[https://msdn.microsoft.com/library/microsoft.sqlserver.management.smo.scriptingoptions_properties.aspx](https://msdn.microsoft.com/library/microsoft.sqlserver.management.smo.scriptingoptions_properties.aspx)

[https://msdn.microsoft.com/library/cc646021.aspx](https://msdn.microsoft.com/library/cc646021.aspx)

