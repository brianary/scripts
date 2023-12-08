---
external help file: -help.xml
Module Name:
online version: https://docs.microsoft.com/dotnet/api/system.security.cryptography.rngcryptoserviceprovider
schema: 2.0.0
---

# Get-RandomBytes.ps1

## SYNOPSIS
Returns random bytes.

## SYNTAX

```
Get-RandomBytes.ps1 [-Count] <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-RandomBytes.ps1 8
```

103
235
194
199
151
83
240
152

## PARAMETERS

### -Count
The number of random bytes to return.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
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

### System.Byte[] of random bytes.
## NOTES

## RELATED LINKS

[https://docs.microsoft.com/dotnet/api/system.security.cryptography.rngcryptoserviceprovider](https://docs.microsoft.com/dotnet/api/system.security.cryptography.rngcryptoserviceprovider)

