---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# New-Jwt.ps1

## SYNOPSIS
Generates a JSON Web Token (JWT)

## SYNTAX

```
New-Jwt.ps1 [[-Body] <IDictionary>] [[-Headers] <IDictionary>] [-Secret] <SecureString> [[-Algorithm] <String>]
 [[-NotBefore] <DateTime>] [[-IssuedAt] <DateTime>] [-IncludeIssuedAt] [[-ExpirationTime] <DateTime>]
 [[-ExpiresAfter] <TimeSpan>] [[-JwtId] <String>] [[-Issuer] <String>] [[-Subject] <String>]
 [[-Audience] <String[]>] [[-Claims] <Hashtable>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
New-Jwt.ps1 -Subject 1234567890 -IssuedAt 2018-01-18T01:30:22Z -Secret (ConvertTo-SecureString swordfish -AsPlainText -Force)
```

eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiaWF0IjoxNTE2MjM5MDIyfQ.59noQVrGQKetFM3RRTe9m4MVBUMkLo3WxqqpPf1xJ-U

## PARAMETERS

### -Body
A hash of JWT body elements.

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: @{}
Accept pipeline input: False
Accept wildcard characters: False
```

### -Headers
Custom headers (beyond typ and alg) to add to the JWT.

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: @{}
Accept pipeline input: False
Accept wildcard characters: False
```

### -Secret
A secret used to sign the JWT.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Algorithm
The hashing algorithm class to use when signing the JWT.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: HS256
Accept pipeline input: False
Accept wildcard characters: False
```

### -NotBefore
When the JWT becomes valid.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IssuedAt
Specifies when the JWT was issued.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeIssuedAt
Indicates the issued time should be included, based on the current datetime (ignored if IssuedAt is provided).

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

### -ExpirationTime
When the JWT expires.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExpiresAfter
How long from now until the JWT expires (ignored if ExpirationTime is provided).

```yaml
Type: TimeSpan
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JwtId
A unique (at least within a given issuer) identifier for the JWT.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Issuer
A string or URI (if it contains a colon) indicating the entity that issued the JWT.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subject
The principal (user) of the JWT as a string or URI (if it contains a colon).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Audience
A string or URI (if it contains a colon), or a list of string or URIs that indicates who the JWT is intended for.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Claims
Additional claims to add to the body of the JWT.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
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

### System.String of an encoded, signed JWT
## NOTES

## RELATED LINKS

[ConvertTo-Base64.ps1]()

[Test-Uri.ps1]()

[https://tools.ietf.org/html/rfc7519](https://tools.ietf.org/html/rfc7519)

[https://jwt.io/](https://jwt.io/)

[https://docs.microsoft.com/dotnet/api/system.security.cryptography.hmac](https://docs.microsoft.com/dotnet/api/system.security.cryptography.hmac)

