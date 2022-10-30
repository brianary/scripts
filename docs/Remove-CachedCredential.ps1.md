---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Remove-CachedCredential.ps1

## SYNOPSIS
Removes a credential from secure storage.

## SYNTAX

```
Remove-CachedCredential.ps1 [-UserName] <String> [-Message] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Remove-CachedCredential.ps1 exampleuser 'OpenTV API login'
```

The credential is removed from secure storage.

## PARAMETERS

### -UserName
Specifies a user or account name that was used to create the credential.

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

### -Message
Provides a login prompt for the user that should be a globally unique description of the purpose of the login.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCredential
## NOTES

## RELATED LINKS

[ConvertTo-Base64.ps1]()

[Stop-ThrowError.ps1]()

