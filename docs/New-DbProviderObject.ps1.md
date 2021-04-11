---
external help file: -help.xml
Module Name:
online version: https://msdn.microsoft.com/library/system.data.common.dbproviderfactories.aspx
schema: 2.0.0
---

# New-DbProviderObject.ps1

## SYNOPSIS
Create a common database object.

## SYNTAX

```
New-DbProviderObject.ps1 [-ProviderName] <String> [-TypeName] <String> [[-InitialValue] <String>]
 [[-ConnectionString] <String>] [-StoredProcedure] [-OpenConnection] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
New-DbProviderObject.ps1 SqlClient ConnectionStringBuilder 'Server=ServerName;Database=DbName;Integrated Security=True'
```

Key                 Value
---                 -----
Data Source         ServerName
Initial Catalog     DbName
Integrated Security True

### EXAMPLE 2
```
$conn = New-DbProviderObject.ps1 SqlClient Connection $connstr -Open
```

($conn contains an open DbConnection object.)

### EXAMPLE 3
```
$cmd = New-DbProviderObject.ps1 odbc Command -ConnectionString $connstr -StoredProcedure -OpenConnection
```

($cmd contains a DbCommand with a CommandType of StoredProcedure and an open connection to $connstr.)

## PARAMETERS

### -ProviderName
The invariant name of the DbProviderFactory to use to create the requested object.

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

### -TypeName
The type of object to create.

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

### -InitialValue
A value to initialize the object with, such as CommandText for a Command object, or
a ConnectionString for a Connection or ConnectionStringBuilder.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Value

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ConnectionString
A connection string to use (when creating a Command object).
No connection will be made if not specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases: CS

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StoredProcedure
Sets the CommandType property of a Command object to StoredProcedure.
Ignored for other objects.

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

### -OpenConnection
Opens the Connection object (or Command connection) if an InitialValue was provided, ignored otherwise.

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

### System.String to initialize the database object.
## OUTPUTS

### System.Data.Common.DbCommand (e.g. System.Data.SqlClient.SqlCommand) or
### System.Data.Common.DbConnection (e.g. System.Data.SqlClient.SqlConnection) or
### System.Data.Common.DbConnectionStringBuilder (e.g. System.Data.SqlClient.SqlConnectionStringBuilder),
### as requested.
## NOTES

## RELATED LINKS

[https://msdn.microsoft.com/library/system.data.common.dbproviderfactories.aspx](https://msdn.microsoft.com/library/system.data.common.dbproviderfactories.aspx)

