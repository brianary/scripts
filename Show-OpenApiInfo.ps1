<#
.SYNOPSIS
Displays metadata from an OpenAPI definition.

.FUNCTIONALITY
Json

.LINK
https://www.openapis.org/

.EXAMPLE
Show-OpenApiInfo.ps1 .\test\data\sample-openapi.json

Sample REST API v1.0.0 An example OpenAPI definition.
.\test\data\sample-openapi.json openapi v3.0.3
GET /users/{userId} Returns a user by ID.
Gets a user's details.
POST /users Creates a new user.
Adds a user account.
#>

#Requires -Version 7
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string] $Path
)
Process
{
    $api = Get-OpenApiInfo.ps1 $Path
    Write-Host $api.Title -ForegroundColor Green -NoNewline
    Write-Host " $($api.Version) " -ForegroundColor DarkCyan -NoNewline
    if($api.Description) {Write-Host $api.Description -ForegroundColor DarkGreen}
    Write-Host $api.Source -ForegroundColor Cyan -NoNewline
    Write-Host " OpenAPI v$($api.OpenApi)" -ForegroundColor DarkCyan
    foreach($endpoint in $api.Endpoints)
    {
        Write-Host $endpoint.Endpoint -ForegroundColor White -NoNewline
        Write-Host ' # ' -ForegroundColor DarkGreen -NoNewline
        Write-Host $endpoint.Summary -ForegroundColor DarkGreen
        Write-Host $endpoint.Description -ForegroundColor DarkGray
    }
}
