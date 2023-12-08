---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Import-Variables.ps1

## SYNOPSIS
Creates local variables from a data row or dictionary (hashtable).

## SYNTAX

```
Import-Variables.ps1 [-InputObject] <PSObject> [-MemberType <PSMemberTypes>] [-Scope <String>] [-Private]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
[^"]+)"\)') {Import-Variables.ps1 $Matches}
```

Copies $Matches.TypeGuid to $TypeGuid if a match is found.

### EXAMPLE 2
```
Invoke-Sqlcmd "select ProductID, Name, ListPrice from Production.Product where ProductID = 1;" -Server 'Server\instance' -Database AdventureWorks |Import-Variables.ps1
```

Copies field values into $ProductID, $Name, and $ListPrice.

### EXAMPLE 3
```
.*?\\)(?<ComExe>[^\\]+$)'){Import-Variables.ps1 $Matches -Verbose}
```

Sets $ComPath and $ComExe from the regex captures if the regex matches.

### EXAMPLE 4
```
Invoke-RestMethod https://api.github.com/ |Import-Variables.ps1 ; Invoke-RestMethod $emojis_url
```

Sets variables from the fields returned by the web service: $current_user_url, $emojis_url, &c.
Then fetches the list of GitHub emojis.

## PARAMETERS

### -InputObject
A hash of string names to any values to set as variables,
or a DataRow or object with properties to set as variables.
Works with DataRows.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -MemberType
The type of object members to convert to variables.

```yaml
Type: PSMemberTypes
Parameter Sets: (All)
Aliases: Type
Accepted values: AliasProperty, CodeProperty, Property, NoteProperty, ScriptProperty, PropertySet, Method, CodeMethod, ScriptMethod, Methods, ParameterizedProperty, MemberSet, Event, Dynamic, InferredProperty, Properties, All

Required: False
Position: Named
Default value: Properties
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scope
The scope of the variables to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Local
Accept pipeline input: False
Accept wildcard characters: False
```

### -Private
Indicates that created variables should be hidden from child scopes.

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

### System.Collections.IDictionary with keys and values to import as variables,
### or System.Management.Automation.PSCustomObject with properties to import as variables.
## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[Add-ScopeLevel.ps1]()

