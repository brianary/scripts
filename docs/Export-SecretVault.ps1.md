---
external help file: -help.xml
Module Name:
online version: https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-are-generally-available/
schema: 2.0.0
---

# Export-SecretVault.ps1

## SYNOPSIS
Exports secret vault content.

## SYNTAX

```
Export-SecretVault.ps1 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Export-SecretVault.ps1 |ConvertTo-Json |Out-File ~/secrets.json utf8
```

Backs up all secrets to a JSON file.

## PARAMETERS

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject with these fields:
### * Name: The secret name, used to identify the secret.
### * Type: The data type of the secret.
### * VaultName: Which vault the secret is stored in.
### * Metadata: A simple hash (string to string/int/datetime) of extra secret context details.
## NOTES

## RELATED LINKS

[https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-are-generally-available/](https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-are-generally-available/)

