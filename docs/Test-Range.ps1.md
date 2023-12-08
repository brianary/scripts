---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# Test-NoteProperty.ps1

## SYNOPSIS
Looks for any matching NoteProperties on an object.

## SYNTAX

```
Test-NoteProperty.ps1 [-Name] <String> -InputObject <PSObject> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
$r = Invoke-RestMethod @args; if(Test-NoteProperty.ps1 -Name Status -InputObject $r) { … }
```

Executes the "if" block if there is a status NoteProperty present.

### EXAMPLE 2
```
Get-Content records.json |ConvertFrom-Json |? {$_ |Test-NoteProperty.ps1 *Addr*} |…
```

Passes objects through the pipeline that have a property containing "Addr" in the name.

## PARAMETERS

### -Name
The name of the property to look for.
Wildcards are supported.

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

### -InputObject
The object to examine.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
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

### System.Management.Automation.PSObject, perhaps created via [PSCustomObject]@{ … }
### or ConvertFrom-Json or Invoke-RestMethod that may have NoteProperties.
## OUTPUTS

### System.Boolean indicating at least one matching NoteProperty was found.
## NOTES

## RELATED LINKS
