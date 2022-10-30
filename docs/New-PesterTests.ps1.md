---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# New-PesterTests.ps1

## SYNOPSIS
Creates a new Pester testing script from a script's examples and parameter sets.

## SYNTAX

### Script
```
New-PesterTests.ps1 [-Script] <String> [-Directory <String>] [-Force] [<CommonParameters>]
```

### Next
```
New-PesterTests.ps1 [-Directory <String>] [-Next] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
New-PesterTests.ps1 New-PesterTests.ps1
```

Creates .\test\New-PesterTests.Tests.ps1 with some boilerplate Pester code.

## PARAMETERS

### -Script
The script to generate tests for.

```yaml
Type: String
Parameter Sets: Script
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Directory
The directory to generate tests in.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Test
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Overwrite an existing tests file.

```yaml
Type: SwitchParameter
Parameter Sets: Script
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Next
Indicates that the next script that's missing a test script file should have one created.

```yaml
Type: SwitchParameter
Parameter Sets: Next
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Stop-ThrowError.ps1]()

