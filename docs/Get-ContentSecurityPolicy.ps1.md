---
external help file: -help.xml
Module Name:
online version: https://content-security-policy.com/
schema: 2.0.0
---

# Get-ContentSecurityPolicy.ps1

## SYNOPSIS
Returns the content security policy at from the given URL.

## SYNTAX

### Uri
```
Get-ContentSecurityPolicy.ps1 [-Uri] <Uri> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Response
```
Get-ContentSecurityPolicy.ps1 -Response <WebResponseObject> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Invoke-WebRequest http://example.org/ |Get-ContentSecurityPolicy.ps1
```

default-src : {http://example.org, http://example.net, 'self'}
script-src  : {'self'}
img-src     : {'self'}
report-uri  : {http://example.com/csp}

## PARAMETERS

### -Uri
The URL to get the policy from.

```yaml
Type: Uri
Parameter Sets: Uri
Aliases: Url

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Response
The output from Invoke-WebRequest to parse the policy from.

```yaml
Type: WebResponseObject
Parameter Sets: Response
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
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

### Microsoft.PowerShell.Commands.WebResponseObject from Invoke-WebRequest
### or
### any object with a Uri or Url property
## OUTPUTS

### System.Management.Automation.PSCustomObject containing the parsed policy.
## NOTES

## RELATED LINKS

[https://content-security-policy.com/](https://content-security-policy.com/)

[Invoke-WebRequest]()

