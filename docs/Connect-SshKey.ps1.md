---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Connect-SshKey.ps1

## SYNOPSIS
Uses OpenSSH to generate a key and connect it to an ssh server.

## SYNTAX

```
Connect-SshKey.ps1 [-HostName] <String> [-UserName <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Connect-SshKey.ps1 crowpi -UserName pi
```

## PARAMETERS

### -HostName
The ssh server to connect to.

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

### -UserName
The remote username to use to connect.

```yaml
Type: String
Parameter Sets: (All)
Aliases: AsUserName

Required: False
Position: Named
Default value: $env:UserName
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
