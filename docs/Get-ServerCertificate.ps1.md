---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-ServerCertificate.ps1

## SYNOPSIS
Returns the certificate provided by the requested server.

## SYNTAX

```
Get-ServerCertificate.ps1 [-Server] <String[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-ServerCertificate.ps1 webcoder.info
```

Server      : webcoder.info
Subject     : CN=webcoder.info
Issuer      : CN=R11, O=Let's Encrypt, C=US
Issued      : 2024-07-06 15:51:57
Expires     : 2024-10-04 15:51:56
Thumbprint  : 363A8CBAB35E6F3254CBB52FE00D0E0E0B3606BC
Certificate : \[Subject\]...
Extensions  : {\[Subject Alternative Name, DNS Name=...
Chain       : System.Security.Cryptography.X509Certificates.X509Chain

## PARAMETERS

### -Server
The server (hostname) to return the TLS/SSL certificate from.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

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

## NOTES

## RELATED LINKS

[Use-Command.ps1]()

