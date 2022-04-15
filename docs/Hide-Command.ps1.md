---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Hide-Command.ps1

## SYNOPSIS
Make a command unavailable.

## SYNTAX

```
Hide-Command.ps1 [-Name] <String> [-CommandType <CommandTypes>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Hide-Command.ps1 Hide-Command.ps1
```

Renames the Hide-Command.ps1 script to Hide-Command.ps1~, making it unavailable.

### EXAMPLE 2
```
Hide-Command.ps1 mkdir
```

Removes the mkdir function.

## PARAMETERS

### -Name
The name of command to hide.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -CommandType
Specifies the types of commands that this cmdlet hides.

```yaml
Type: CommandTypes
Parameter Sets: (All)
Aliases:
Accepted values: Alias, Function, Filter, Cmdlet, ExternalScript, Application, Script, Configuration, All

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String containing a command name, or an object with a Name of a command
### and maybe a specific CommandType.
## OUTPUTS

## NOTES

## RELATED LINKS

[Stop-ThrowError.ps1]()

[Get-Command]()

