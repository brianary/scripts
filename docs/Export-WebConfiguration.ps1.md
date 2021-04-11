---
external help file: -help.xml
Module Name:
online version: https://chocolatey.org/
schema: 2.0.0
---

# Export-WebConfiguration.ps1

## SYNOPSIS
Exports IIS websites, app pools, and web apps as an idempotent PowerShell script to recreate them.

## SYNTAX

```
Export-WebConfiguration.ps1 [[-Path] <String>] [[-Stores] <X509Store[]>]
 [[-X509KeyStorageFlags] <X509KeyStorageFlags>] [<CommonParameters>]
```

## DESCRIPTION
This script writes an import script that can be used to reproduce the IIS settings of the server
the export is run on.

The goal is to create an import script that is understandable, editable, can be stepped through,
and fails recoverably with intuitive remediation rather than failing catastrophically with
no remediation steps or clarity.

Special emphasis is made on supporting running the export on older versions of PowerShell & Windows
(IIS7+), with an expectation to run the import on a slightly newer version (IIS8+).

## EXAMPLES

### EXAMPLE 1
```
Export-WebConfiguration.ps1
```

## PARAMETERS

### -Path
File to write import script text to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: "Import-${env:ComputerName}WebConfiguration.ps1"
Accept pipeline input: False
Accept wildcard characters: False
```

### -Stores
{{ Fill Stores Description }}

```yaml
Type: X509Store[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: ((Get-Item 'Cert:\LocalMachine\My'), (Get-Item 'Cert:\LocalMachine\TrustedPeople'))
Accept pipeline input: False
Accept wildcard characters: False
```

### -X509KeyStorageFlags
{{ Fill X509KeyStorageFlags Description }}

```yaml
Type: X509KeyStorageFlags
Parameter Sets: (All)
Aliases:
Accepted values: DefaultKeySet, UserKeySet, MachineKeySet, Exportable, UserProtected, PersistKeySet, EphemeralKeySet

Required: False
Position: 3
Default value: Exportable,MachineKeySet,PersistKeySet
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

[https://docs.microsoft.com/en-us/iis/configuration/system.webserver/](https://docs.microsoft.com/en-us/iis/configuration/system.webserver/)

[https://docs.microsoft.com/en-us/iis/manage/powershell/powershell-snap-in-creating-web-sites-web-applications-virtual-directories-and-application-pools](https://docs.microsoft.com/en-us/iis/manage/powershell/powershell-snap-in-creating-web-sites-web-applications-virtual-directories-and-application-pools)

[https://blog.kloud.com.au/2013/04/18/an-overview-of-server-name-indication-sni-and-creating-an-iis-sni-web-ssl-binding-using-powershell-in-windows-server-2012/](https://blog.kloud.com.au/2013/04/18/an-overview-of-server-name-indication-sni-and-creating-an-iis-sni-web-ssl-binding-using-powershell-in-windows-server-2012/)

[https://stackoverflow.com/a/26391894/54323](https://stackoverflow.com/a/26391894/54323)

[https://docs.microsoft.com/en-us/iis/configuration/system.applicationHost/applicationPools/add/processModel](https://docs.microsoft.com/en-us/iis/configuration/system.applicationHost/applicationPools/add/processModel)

[https://docs.microsoft.com/en-us/iis/manage/powershell/powershell-snap-in-changing-simple-settings-in-configuration-sections](https://docs.microsoft.com/en-us/iis/manage/powershell/powershell-snap-in-changing-simple-settings-in-configuration-sections)

[https://stackoverflow.com/a/14879480/54323](https://stackoverflow.com/a/14879480/54323)

[https://stackoverflow.com/a/25807484/54323](https://stackoverflow.com/a/25807484/54323)

[https://blogs.iis.net/jeonghwan/examples-of-iis-powershell-cmdlets](https://blogs.iis.net/jeonghwan/examples-of-iis-powershell-cmdlets)

[https://docs.microsoft.com/en-us/iis/manage/powershell/powershell-snap-in-configuring-ssl-with-the-iis-powershell-snap-in](https://docs.microsoft.com/en-us/iis/manage/powershell/powershell-snap-in-configuring-ssl-with-the-iis-powershell-snap-in)

[https://github.com/PowerShell/xWebAdministration](https://github.com/PowerShell/xWebAdministration)

[https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509certificate2.aspx](https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509certificate2.aspx)

[https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509store.aspx](https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509store.aspx)

[https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509keystorageflags.aspx](https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509keystorageflags.aspx)

[https://msdn.microsoft.com/library/system.convert.aspx](https://msdn.microsoft.com/library/system.convert.aspx)

[Format-Certificate.ps1]()

[Get-WebGlobalModule]()

[New-WebAppPool]()

[Get-Website]()

[New-Website]()

[Get-WebBinding]()

[New-WebBinding]()

[Get-WebApplication]()

[New-WebApplication]()

[Set-WebConfigurationProperty]()

[Write-Progress]()

[Get-Item]()

[Get-ItemProperty]()

[Set-ItemProperty]()

