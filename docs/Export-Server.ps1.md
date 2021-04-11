---
external help file: -help.xml
Module Name:
online version: https://chocolatey.org/
schema: 2.0.0
---

# Export-Server.ps1

## SYNOPSIS
Exports web server settings, shares, ODBC DSNs, and installed MSAs as PowerShell scripts and data.

## SYNTAX

```
Export-Server.ps1 [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Export-WebServer.ps1
```

Exports server settings as PowerShell scripts and data, including any of:

- An editable script specified by the Path parameter (Import-${env:ComputerName}.ps1 by default)
- Import-${env:ComputerName}WebConfiguration.ps1 for IIS settings
- Import-${env:ComputerName}SmbShares.ps1 for Windows file shares
- hosts containing customized hosts file entries
- ODBC.reg containing ODBC system DSNs
- *.dsn, each an ODBC file DSN found in the default file DSN path ${env:CommonProgramFiles}\ODBC\Data Sources
- InstalledApplications.txt containing a list of non-Microsoft applications in "Programs and Features"
  (Add/Remove Programs in older Windows versions)

## PARAMETERS

### -Path
The path of the script to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: "Import-${env:ComputerName}.ps1"
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

[https://chocolatey.org/](https://chocolatey.org/)

[Export-WebConfiguration.ps1]()

[Export-SmbShare.ps1]()

