---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-SecretDetails.ps1

## SYNOPSIS
Returns secret info from the secret vaults, including metadata as properties.

## SYNTAX

```
Get-SecretDetails.ps1 [-ProgressAction <ActionPreference>] [-Name <String>] [-Vault <String>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-SecretDetails.ps1
```

Name        : test-creds
Type        : PSCredential
VaultName   : SecretStore
Title       : Test
Description : Example credentials.
Note        : Just for testing.
Uri         : https://example.org/
Created     : 2024-12-31 00:00:00
Expires     : 2036-01-01 00:00:00

## PARAMETERS

### -Name
{{ Fill Name Description }}

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

### -Vault
{{ Fill Vault Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
