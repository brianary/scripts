---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Add-ScriptCredential.ps1

## SYNOPSIS
Serializes a an encrypted credential to a PowerShell script using 32-byte random key file.

## SYNTAX

```
Add-ScriptCredential.ps1 [-Path] <String> [-Name] <String> [-Credential] <PSCredential> [-KeyFile <String>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```

```

## PARAMETERS

### -Path
The script path to add the serialized credential to.

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

### -Name
The variable name to assign the credential to within the script.

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

### -Credential
The credential to serialize.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -KeyFile
The key file to use, which will be generated and encrypted if it doesn't exist.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: ~/.pskey
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSCredential containing a credential to serialize.
## OUTPUTS

## NOTES

## RELATED LINKS

[ConvertTo-PowerShell.ps1]()

[https://docs.microsoft.com/dotnet/api/system.security.cryptography.rngcryptoserviceprovider](https://docs.microsoft.com/dotnet/api/system.security.cryptography.rngcryptoserviceprovider)

