---
external help file: -help.xml
Module Name:
online version: https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-are-generally-available/
schema: 2.0.0
---

# Import-SecretVault.ps1

## SYNOPSIS
Imports secrets into secret vaults.

## SYNTAX

```
Import-SecretVault.ps1 [[-Name] <String>] [[-Type] <String>] [[-Value] <PSObject>] [[-Vault] <String>]
 [[-Metadata] <PSObject>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-Content ~/secrets.json |ConvertFrom-Json |Import-SecretVault.ps1
```

Restores secrets to vaults.

## PARAMETERS

### -Name
{{ Fill Name Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Type
{{ Fill Type Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Value
{{ Fill Value Description }}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Vault
{{ Fill Vault Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Metadata
{{ Fill Metadata Description }}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject with these fields:
### * Name: The secret name, used to identify the secret.
### * Type: The data type of the secret.
### * VaultName: Which vault the secret is stored in.
### * Metadata: A simple hash (string to string/int/datetime) of extra secret context details.
## OUTPUTS

## NOTES
This is likely the configuration you'll need to run this:
Set-SecretStoreConfiguration -Scope CurrentUser -Authentication None -Interaction None

## RELATED LINKS

[https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-are-generally-available/](https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-are-generally-available/)

