---
external help file: -help.xml
Module Name:
online version: https://www.openapis.org/
schema: 2.0.0
---

# Export-OpenApiSchema.ps1

## SYNOPSIS
Extracts the JSON schema from an OpenAPI definition.

## SYNTAX

### ResponseStatus (Default)
```
Export-OpenApiSchema.ps1 [[-Path] <String>] [[-Method] <String>] [[-EndpointPath] <String>]
 [[-ResponseStatus] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### RequestSchema
```
Export-OpenApiSchema.ps1 [[-Path] <String>] [[-Method] <String>] [[-EndpointPath] <String>] [-RequestSchema]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Export-OpenApiSchema.ps1 api.json
```

Returns the schema of the 200 response of any defined endpoint is returned.

### EXAMPLE 2
```
Export-OpenApiSchema.ps1 api.json POST /hello -RequestSchema
```

Returns the schema of the request body of the POST /hello endpoint.

## PARAMETERS

### -Path
The path to the OpenAPI JSON file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
The HTTP verb of the endpoint to extract the schema from.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndpointPath
The HTTP path of the endpoint to extract the schema from.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ApiPath

Required: False
Position: 3
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequestSchema
Indicates that the request schema of the endpoint should be returned.

```yaml
Type: SwitchParameter
Parameter Sets: RequestSchema
Aliases: In

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResponseStatus
Indicates the HTTP status code of the response schema of the endpoint that should be returned.

```yaml
Type: Int32
Parameter Sets: ResponseStatus
Aliases:

Required: False
Position: 4
Default value: 200
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

### System.String of the extracted JSON schema.
## NOTES

## RELATED LINKS

[https://www.openapis.org/](https://www.openapis.org/)

[Export-Json.ps1]()

[Set-Json.ps1]()

