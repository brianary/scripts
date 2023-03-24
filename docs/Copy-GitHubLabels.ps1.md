---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Copy-GitHubLabels.ps1

## SYNOPSIS
Copies configured issue labels from one repo to another.

## SYNTAX

```
Copy-GitHubLabels.ps1 [-OwnerName] <String> [-RepositoryName] <String> [-DestinationOwnerName <String>]
 -DestinationRepositoryName <String> [-Mode <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Copy-GitHubLabels.ps1 -OwnerName brianary -RepositoryName scripts -DestinationRepositoryName webcoder
```

Inserts new labels from the brianary/scripts repo to the brianary/webcoder repo, and also
updates attributes like description and color from matching labels in the source.

## PARAMETERS

### -OwnerName
The source repository's owner name.

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

### -RepositoryName
The source repository name.

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

### -DestinationOwnerName
The destination repository's owner name.

```yaml
Type: String
Parameter Sets: (All)
Aliases: owner

Required: False
Position: Named
Default value: $OwnerName
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DestinationRepositoryName
The destination repository name.

```yaml
Type: String
Parameter Sets: (All)
Aliases: name

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Mode
Determines the copy behavior:
* AddNew: Insert new labels from the source.
* AddAndUpdate: Insert new labels from the source, and also overwrite attributes from matching labels in the source.
* ReplaceAll: Insert new labels from the source, overwrite attributes from matching labels in the source, and delete
  any labels that don't exist in the source.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: AddAndUpdate
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### An object with these properties:
### * owner or DestinationOwnerName (optional)
### * name or DestinationRepositoryName
## OUTPUTS

## NOTES

## RELATED LINKS

[Get-GitHubLabel]()

[New-GitHubLabel]()

[Set-GitHubLabel]()

[Remove-GitHubLabel]()

