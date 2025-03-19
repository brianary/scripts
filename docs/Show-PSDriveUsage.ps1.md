---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Show-OpenApiInfo.ps1

## SYNOPSIS
Displays metadata from an OpenAPI definition.

## SYNTAX

```
Show-OpenApiInfo.ps1 [-Path] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Show-OpenApiInfo.ps1 .\test\data\sample-openapi.json
```

Sample REST API v1.0.0 An example OpenAPI definition.
.\test\data\sample-openapi.json openapi v3.0.3
GET /users/{userId} Returns a user by ID.
Gets a user's details.
POST /users Creates a new user.
Adds a user account.

## PARAMETERS

### -Path
{{ Fill Path Description }}

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

## OUTPUTS

## NOTES

## RELATED LINKS

[https://www.openapis.org/](https://www.openapis.org/)

