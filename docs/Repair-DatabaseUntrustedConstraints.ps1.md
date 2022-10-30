---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Repair-DatabaseUntrustedConstraints.ps1

## SYNOPSIS
Finds database constraints that have been incompletely re-enabled.

## SYNTAX

### ByConnectionParameters
```
Repair-DatabaseUntrustedConstraints.ps1 [-ServerInstance] <String> [-Database] <String> [-Update] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### ByConnectionString
```
Repair-DatabaseUntrustedConstraints.ps1 -ConnectionString <String> [-Update] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ByConnectionName
```
Repair-DatabaseUntrustedConstraints.ps1 -ConnectionName <String> [-Update] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Repair-DatabaseUntrustedConstraints.ps1 SqlServerName DatabaseName -Update
```

WARNING: Checked 2 constraints

## PARAMETERS

### -ServerInstance
The name of a server (and optional instance) to connect to.

```yaml
Type: String
Parameter Sets: ByConnectionParameters
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Database
The the database to connect to on the server.

```yaml
Type: String
Parameter Sets: ByConnectionParameters
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectionString
Specifies a connection string to connect to the server.

```yaml
Type: String
Parameter Sets: ByConnectionString
Aliases: ConnStr, CS

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectionName
The connection string name from the ConfigurationManager to use.

```yaml
Type: String
Parameter Sets: ByConnectionName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Update
Update the database when present, otherwise simply outputs the changes as script.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[Use-SqlcmdParams.ps1]()

[Invoke-Sqlcmd]()

[https://www.brentozar.com/blitz/foreign-key-trusted/](https://www.brentozar.com/blitz/foreign-key-trusted/)

