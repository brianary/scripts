---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-ModuleScope.ps1

## SYNOPSIS
Returns the scope of an installed module.

## SYNTAX

```
Get-ModuleScope.ps1 [[-Name] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-ModuleScope.ps1 Detextive
```

ModuleName Scope
---------- -----
Detextive  CurrentUser

### EXAMPLE 2
```
Get-ModuleScope.ps1 Pester
```

ModuleName Scope
---------- -----
Pester     CurrentUser
Pester     AllUsers

## PARAMETERS

### -Name
Specifies names or name patterns of modules that this cmdlet gets.
Wildcard characters are permitted.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ModuleName

Required: False
Position: 1
Default value: *
Accept pipeline input: True (ByPropertyName)
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

### System.Object with a "Name" or "ModuleName" property containing a module name.
## OUTPUTS

### System.Management.Automation.PSObject with the following properties:
### * ModuleName: The name of the module.
### * Scope: The value "CurrentUser" if the module is found within $HOME\Documents\PowerShell\Modules, "AllUsers" if found anywhere else.
## NOTES

## RELATED LINKS
