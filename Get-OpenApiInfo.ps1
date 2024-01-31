<#
.SYNOPSIS
Returns metadata from an OpenAPI definition.

.FUNCTIONALITY
Json

.LINK
https://www.openapis.org/
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string] $Path
)
Process
{
	Get-Content $Path -Raw |
		ConvertFrom-Json -AsHashtable |
		ForEach-Object {[pscustomobject]@{
			Source      = $Path
			Swagger     = $_.swagger
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