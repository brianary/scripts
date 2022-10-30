---
external help file: -help.xml
Module Name:
online version: https://tools.ietf.org/html/rfc1945#section-11.1
schema: 2.0.0
---

# ConvertTo-BasicAuthentication.ps1

## SYNOPSIS
Produces a basic authentication header string from a credential.

## SYNTAX

```
ConvertTo-BasicAuthentication.ps1 [-Credential] <PSCredential> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Invoke-RestMethod https://example.com/api/items -Method Get -Headers @{Authorization=ConvertTo-BasicAuthentication.ps1 (Get-Credential -Message 'Log in')}
```

Calls a REST method that requires Basic authentication on the first request (with no challenge-response support).

## PARAMETERS

### -Credential
Specifies a user account to authenticate an HTTP request that only accepts Basic authentication.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSCredential to convert to the Authorization HTTP header value.
## OUTPUTS

### System.String to use as the Authorization HTTP header value.
## NOTES

## RELATED LINKS

[https://tools.ietf.org/html/rfc1945#section-11.1](https://tools.ietf.org/html/rfc1945#section-11.1)

[http://stackoverflow.com/q/24672760/54323](http://stackoverflow.com/q/24672760/54323)

[https://weblog.west-wind.com/posts/2010/Feb/18/NET-WebRequestPreAuthenticate-not-quite-what-it-sounds-like](https://weblog.west-wind.com/posts/2010/Feb/18/NET-WebRequestPreAuthenticate-not-quite-what-it-sounds-like)

[https://powershell.org/forums/topic/pscredential-parameter-help/](https://powershell.org/forums/topic/pscredential-parameter-help/)

