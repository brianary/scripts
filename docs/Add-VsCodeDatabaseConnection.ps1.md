---
external help file: -help.xml
Module Name:
online version: https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql
schema: 2.0.0
---

# Add-VsCodeDatabaseConnection.ps1

## SYNOPSIS
Adds a VS Code MSSQL database connection to the repo.

## SYNTAX

```
Add-VsCodeDatabaseConnection.ps1 [-ProfileName] <String> [-ServerInstance] <String> [-Database] <String>
 [[-UserName] <String>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Add-VsCodeDatabaseConnection.ps1 ConnectionName ServerName\instance DatabaseName
```

Adds an MSSQL extension trusted connection named ConnectionName that
connects to the server ServerName\instance and database DatabaseName.

## PARAMETERS

### -ProfileName
The name of the connection.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ServerInstance
The name of a server (and optional instance) to connect and use for the query.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Server, DataSource

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Database
The the database to connect to on the server.

```yaml
Type: String
Parameter Sets: (All)
Aliases: InitialCatalog

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -UserName
The username to connect with.
No password will be stored.
If no username is given, a trusted connection will be created.

```yaml
Type: String
Parameter Sets: (All)
Aliases: UID

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Force
Overwrite an existing profile with the same name.

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

### System.Void
## NOTES

## RELATED LINKS

[https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql](https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql)

[Get-VSCodeSetting.ps1]()

[Set-VSCodeSetting.ps1]()

