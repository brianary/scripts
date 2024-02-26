<#
.SYNOPSIS
Extracts a JSON schema from an OpenAPI definition.

.OUTPUTS
System.String of the extracted JSON schema.

.FUNCTIONALITY
Json

.LINK
https://www.openapis.org/

.LINK
Export-Json.ps1

.LINK
Set-Json.ps1

.EXAMPLE
Export-OpenApiSchema.ps1 api.json

Returns the schema of the 200 response of any defined endpoint is returned.

.EXAMPLE
Export-OpenApiSchema.ps1 api.json POST /hello -RequestSchema

Returns the schema of the request body of the POST /hello endpoint.
#>

#Requires -Version 7
[CmdletBinding(DefaultParameterSetName='ResponseStatus')][OutputType([string])] Param(
# The path to the OpenAPI JSON file.
[Parameter(Position=0)][string] $Path,
# The HTTP verb of the endpoint to extract the schema from.
[Parameter(Position=1)][string] $Method = '*',
# The HTTP path of the endpoint to extract the schema from.
[Parameter(Position=2)][Alias('ApiPath')][string] $EndpointPath = '*',
# Indicates that the request schema of the endpoint should be returned.
[Parameter(ParameterSetName='RequestSchema')][Alias('In')][switch] $RequestSchema,
# Indicates the HTTP status code of the response schema of the endpoint that should be returned.
[Parameter(ParameterSetName='ResponseStatus',Position=3)][int] $ResponseStatus = 200
)
Process
{
    $Method = $Method.ToLowerInvariant()
    return ($PSCmdlet.ParameterSetName -eq 'RequestSchema' `
        ? (Export-Json.ps1 "/paths/$EndpointPath/$Method/parameters/*/schema" -Path $Path)
        : (Export-Json.ps1 "/paths/$EndpointPath/$Method/responses/$ResponseStatus/content/*/schema" -Path $Path) ) |
        Set-Json.ps1 '/$schema' 'http://json-schema.org/draft-04/schema#'
}
