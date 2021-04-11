---
external help file: -help.xml
Module Name:
online version: https://stackoverflow.com/questions/3460982/determine-net-framework-version-for-dll#25649840
schema: 2.0.0
---

# Get-AssemblyFramework.ps1

## SYNOPSIS
Gets the framework version an assembly was compiled for.

## SYNTAX

```
Get-AssemblyFramework.ps1 [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-AssemblyFramework.ps1 Program.exe
```

RuntimeVersion CompileVersion
-------------- --------------
v4.0.30319     .NETFramework,Version=v4.7.2

## PARAMETERS

### -Path
The assembly to get the framework version of.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Objects with System.String properties named Path or FullName.
## OUTPUTS

### System.Management.Automation.PSCustomObject with RuntimeVersion and CompileVersion properties.
## NOTES

## RELATED LINKS

[https://stackoverflow.com/questions/3460982/determine-net-framework-version-for-dll#25649840](https://stackoverflow.com/questions/3460982/determine-net-framework-version-for-dll#25649840)

