---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# Get-ADServiceAccountInfo.ps1

## SYNOPSIS
Lists the Global Managed Service Accounts for the domain, including the computers they are bound to.

## SYNTAX

```
Get-ADServiceAccountInfo.ps1 [[-Filter] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-ADServiceAccountInfo.ps1 |Format-Table -AutoSize
```

Name     HostComputers LastLogonDate       Description Account
----     ------------- -------------       ----------- -------
service1 SERVERA       2023-08-27 11:14:19 First MSA   {}
service2 SERVERB       2023-08-27 10:27:03 Second MSA  {}
serivce3 SERVERC       2023-08-25 17:19:49 Third MSA   {}

## PARAMETERS

### -Filter
{{ Fill Filter Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
