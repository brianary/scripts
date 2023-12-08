---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Use-ReasonableDefaults.ps1

## SYNOPSIS
Sets certain cmdlet parameter defaults to rational, useful values.

## SYNTAX

```
Use-ReasonableDefaults.ps1 [-LatestSecurityProtocol] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Use-ReasonableDefaults.ps1
```

Sets the security protocol to TLS 1.2.

Sets default values:
	Out-File -Encoding UTF8 -Width (\[int\]::MaxValue)
	Export-Csv -NoTypeInformation
	Invoke-WebRequest -UseBasicParsing
	Select-Xml -Namespace @{ a bunch of standard namespaces }

## PARAMETERS

### -LatestSecurityProtocol
Use the greatest value of the System.Net.SecurityProtocolType enum.

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

### System.Void
## NOTES

## RELATED LINKS

[Use-NetMailConfig.ps1]()

[Set-ParameterDefault.ps1]()

[Get-EnumValues.ps1]()

