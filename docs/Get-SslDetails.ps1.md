---
external help file: -help.xml
Module Name:
online version: https://msdn.microsoft.com/library/system.security.authentication.sslprotocols.aspx
schema: 2.0.0
---

# Get-SslDetails.ps1

## SYNOPSIS
Enumerates the SSL protocols that the client is able to successfully use to connect to a server.

## SYNTAX

```
Get-SslDetails.ps1 [-ComputerName] <String> [[-Port] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-SslDetails.ps1 -ComputerName www.google.com
```

ComputerName       : www.google.com
Port               : 443
KeyLength          : 2048
SignatureAlgorithm : rsa-sha1
CertificateIssuer  : Google Inc
CertificateExpires : 06/20/2018 06:22:00
Ssl2               : False
Ssl3               : False
Tls                : Aes128
Tls11              : Aes128
Tls12              : Aes128

## PARAMETERS

### -ComputerName
The name of the remote computer to connect to.

```yaml
Type: String
Parameter Sets: (All)
Aliases: CN, Hostname

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Port
The remote port to connect to.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 443
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String of hostname(s) to get SSL support and certificate details for.
## OUTPUTS

### System.Management.Automation.PSCustomObject with certifcated details and
### properties indicating support for SSL protocols with the cypher algorithm used
### if supported or false if not supported.
## NOTES

## RELATED LINKS

[https://msdn.microsoft.com/library/system.security.authentication.sslprotocols.aspx](https://msdn.microsoft.com/library/system.security.authentication.sslprotocols.aspx)

[https://msdn.microsoft.com/library/system.net.security.sslstream.authenticateasclient.aspx](https://msdn.microsoft.com/library/system.net.security.sslstream.authenticateasclient.aspx)

[Get-EnumValues.ps1]()

