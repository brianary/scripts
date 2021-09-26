---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-DotNetFrameworkVersions.ps1

## SYNOPSIS
Determine which .NET Frameworks are installed on the requested system.

## SYNTAX

```
Get-DotNetFrameworkVersions.ps1 [[-ComputerName] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-DotNetFrameworkVersions.ps1
```

Name                           Value
----                           -----
v4.6.2+win10ann                4.6.1586
v3.5                           3.5.30729.4926
v2.0.50727                     2.0.50727.4927
v3.0                           3.0.30729.4926

## PARAMETERS

### -ComputerName
The computer to list the installed .NET Frameworks for.

```yaml
Type: String
Parameter Sets: (All)
Aliases: CN, Server

Required: False
Position: 1
Default value: $env:COMPUTERNAME
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Collections.Hashtable of semantic version names to version numbers
### of .NET frameworks installed.
## NOTES

## RELATED LINKS
