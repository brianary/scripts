---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Use-Java.ps1

## SYNOPSIS
Switch the Java version for the current process by modifying environment variables.

## SYNTAX

```
Use-Java.ps1 [-Path] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Use-Java.ps1 "$env:ProgramFiles\OpenJDK\jdk-11.0.1"
```

## PARAMETERS

### -Path
The path to the JRE/JDK to use, which must contain bin\java.exe.

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

### System.String path to use as the new JAVA_HOME environment variable.
## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS
