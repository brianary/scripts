---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# Initialize-DatabaseNotebook.ps1

## SYNOPSIS
Populates a new notebook with details about a database.

## SYNTAX

```
Initialize-DatabaseNotebook.ps1 [-ServerInstance] <String> [-DatabaseName] <String> [-DisableEncryption]
 [-AllowWrites] [-Readme <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Initialize-DatabaseNotebook.ps1 -ServerInstance ServerName -DatabaseName AdventureWorks
```

Adds cells to the current Polyglot Notebook that generates a header, ER diagram, and table stats.

## PARAMETERS

### -ServerInstance
The name of a server (and optional instance) to connect and use for the query.

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

### -DatabaseName
The the database to connect to on the server.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableEncryption
By default, an encryped connection is used.
This disables that for certain compatibility issues.

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

### -AllowWrites
By default, a read-only connection is used.
This disables that and allows read/write operations,
for certain compatibility issues or other needs.

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

### -Readme
The path to a static Markdown README.md file to create in parallel since the notebook readme
isn't fully supported yet.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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

## OUTPUTS

## NOTES

## RELATED LINKS
