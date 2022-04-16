---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-CachedCredential.ps1

## SYNOPSIS
Return a credential from secure storage, or prompt the user for it if not found.

## SYNTAX

```
Get-CachedCredential.ps1 [-UserName] <String> [-Message] <String> [-Vault <String>] [-UseFile] [-Force]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
$cred = Get-CachedCredential.ps1 exampleuser 'OpenTV API login'
```

$cred now contains the login information entered, either this time or from a previous execution.

## PARAMETERS

### -UserName
Specifies a user or account name for the authentication prompt to request a password for.

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

### -Vault
The name of the secret vault to retrieve the Pocket API consumer key from.
By default, the default vault is used.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseFile
Indicates that the old-style filesystem-based credential store should be used.

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

### -Force
Indicates the login should be manual and overwrite any cached value.

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

### System.Management.Automation.PSCredential entered by the user, potentially loaded from the cache.
## NOTES

## RELATED LINKS

[ConvertTo-Base64.ps1]()

[Stop-ThrowError.ps1]()

