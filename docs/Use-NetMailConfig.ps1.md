---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Use-NetMailConfig.ps1

## SYNOPSIS
Use .NET configuration to set defaults for Send-MailMessage.

## SYNTAX

```
Use-NetMailConfig.ps1 [[-Scope] <String>] [-Private] [<CommonParameters>]
```

## DESCRIPTION
The configuration system provides a place to set email defaults:

\<system.net\>
  \<mailSettings\>
    \<smtp from="source@example.org" deliveryMethod="network"\>
      \<network host="mail.example.org" enableSsl="true" /\>
    \</smtp\>
  \</mailSettings\>
\</system.net\>

The values for Send-MailMessage's From, SmtpServer, and UseSsl will be
taken from whatever is set in the machine.config (or more localized config).

## EXAMPLES

### EXAMPLE 1
```
Use-NetMailConfig.ps1
```

Sets Send-MailMessage defaults for From, SmtpServer, and UseSsl to
values from the ConfigurationManager.

## PARAMETERS

### -Scope
The scope to create the defaults in.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Local
Accept pipeline input: False
Accept wildcard characters: False
```

### -Private
Indicates the defaults should not be visible to child scopes.

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

[Add-ScopeLevel.ps1]()

[Set-ParameterDefault.ps1]()

[Send-MailMessage]()

