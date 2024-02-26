<#
.SYNOPSIS
Tests extracting a JSON schema from an OpenAPI definition.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Export-OpenApiSchema' -Tag Export-OpenApiSchema -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
		$datadir = Join-Path $PSScriptRoot 'data'
	}
	Context 'Extracts a JSON schema from an OpenAPI definition' -Tag ExportOpenApiSchema,Export,OpenApi {
		It "Exports the response schema from sample schema" {
			Export-OpenApiSchema.ps1 (Join-Path $datadir sample-openapi.json) |Should -BeExactly @'
{
  "required": [
    "id",
    "name"
  ],
  "properties": {
    "id": {
      "type": "integer",
      "example": 4
    },
    "name": {
      "type": "string",
      "example": "Arthur Dent"
    }
  },
  "type": "object",
  "$schema": "http://json-schema.org/draft-04/schema#"
}
'@
		}
		It "Exports the request schema from sample schema" {
			Export-OpenApiSchema.ps1 (Join-Path $datadir sample-openapi.json) -RequestSchema |Should -BeExactly @'
{
  "type": "integer",
  "minimum": 1,
  "format": "int64",
  "$schema": "http://json-schema.org/draft-04/schema#"
}
'@
		}
	}
}
