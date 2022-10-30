---
external help file: -help.xml
Module Name:
online version: https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql
schema: 2.0.0
---

# Import-VsCodeDatabaseConnections.ps1

## SYNOPSIS
Adds config XDT connection strings to VSCode settings.

## SYNTAX

```
Import-VsCodeDatabaseConnections.ps1 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Import-VsCodeDatabaseConnections.ps1
```

Adds any new (by name) connection strings found in XDT .config files into
the .vscode/settings.json mssql.connections collection for the mssql extension.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql](https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql)

[http://code.visualstudio.com/](http://code.visualstudio.com/)

[https://git-scm.com/docs/git-rev-parse](https://git-scm.com/docs/git-rev-parse)

[Get-ConfigConnectionStringBuilders.ps1]()

[Split-FileName.ps1]()

[Import-Variables.ps1]()

[ConvertFrom-Json]()

[ConvertTo-Json]()

[Add-Member]()

[Test-Path]()

