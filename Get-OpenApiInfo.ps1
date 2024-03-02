<#
.SYNOPSIS
Returns metadata from an OpenAPI definition.

.FUNCTIONALITY
Json

.LINK
https://www.openapis.org/

.EXAMPLE
Get-OpenApiInfo.ps1 .\test\data\sample-openapi.json

Source      : .\test\data\sample-openapi.json
OpenApi     : 3.0.3
Title       : Sample REST API
Description : An example OpenAPI definition.
Version     : 1.0.0
Endpoints   : {@{Endpoint=GET /users/{userId}; Summary=Returns a user by ID.; Description=Gets a user's details.},
|             @{Endpoint=POST /users; Summary=Creates a new user.; Description=Adds a user account.}}
#>

#Requires -Version 7
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string] $Path
)
Process
{
	Get-Content $Path -Raw |
		ConvertFrom-Json -AsHashtable |
		ForEach-Object {[pscustomobject]@{
			Source      = $Path
			OpenApi     = $_.ContainsKey('openapi') ? $_.openapi :
				$_.ContainsKey('swagger') ? $_.swagger : $null
			Title       = $_.info.title
			Description = $_.info.description
			Version     = $_.info.version
			Endpoints   = $_.paths.GetEnumerator() |% {
				$p = $_.Key
				$e = $_.Value
				$_.Value.Keys |% {
					[pscustomobject]@{
						Endpoint    = "$($_.ToUpperInvariant()) $p"
						Summary     = $e[$_].summary
						Description = $e[$_].description
					}
				}
			}
		}}
}