---
external help file: -help.xml
Module Name:
online version: https://msdn.microsoft.com/library/microsoft.sqlserver.management.smo.aspx
schema: 2.0.0
---

# Export-DatabaseScripts.ps1

## SYNOPSIS
Exports MS SQL database objects from the given server and database as files, into a consistent folder structure.

## SYNTAX

```
Export-DatabaseScripts.ps1 [-Server] <String> [-Database] <String> [[-Encoding] <String>]
 [[-ScriptingOptions] <String[]>] [-SqlVersion <SqlServerVersion>] [<CommonParameters>]
```

## DESCRIPTION
This script exports all database objects as scripts into a subdirectory with the same name as the database,
and further subdirectories by object type.
The directory is deleted and recreated each time this script is
run, to clean up objects that have been deleted from the database.

There are a default set of SMO scripting options set to do a typical export, though these may be overridden
(see the link below for a list of these options).

This does require SMO to be installed on the machine (it comes with SQL Management Studio).

## EXAMPLES

### EXAMPLE 1
```
Export-SqlScripts.ps1 ServerName\instance AdventureWorks2014
```

Outputs SQL scripts to files.

## PARAMETERS

### -Server
The name of the server (and instance) to connect to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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
Aliases:

Required: True
Position: 2
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
Position: 3
Default value: UTF8
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
Position: 4
Default value: (@'
EnforceScriptingOptions ExtendedProperties Permissions DriAll Indexes Triggers ScriptBatchTerminator
'@.Trim() -split '\W+')
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

## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[https://msdn.microsoft.com/library/microsoft.sqlserver.management.smo.aspx](https://msdn.microsoft.com/library/microsoft.sqlserver.management.smo.aspx)

[https://msdn.microsoft.com/library/microsoft.sqlserver.management.smo.scriptingoptions_properties.aspx](https://msdn.microsoft.com/library/microsoft.sqlserver.management.smo.scriptingoptions_properties.aspx)

[Install-SqlServerModule.ps1]()

