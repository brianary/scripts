<#
.Synopsis
	Try parsing text as XML, and validating it if a schema is provided.

.Parameter Xml
	The string to check.

.Parameter Path
	A file to check.

.Parameter Schemata
	A hashtable of schema namespaces to schema locations (in addition to the xsi:schemaLocation attribute).

.Parameter Warning
	Indicates that well-formedness or validation errors will result in warnings being written.

.Parameter ErrorMessage
	When present, returns the well-formedness or validation error message, or nothing if successful
	(instead of a boolean value).

.Inputs
	System.String containing a file path or potential XML data.

.Outputs
	System.Boolean indicating the XML is parseable, or System.String containing the
	parse error if -ErrorMessage is present and the XML isn't parseable.

.Link
	https://www.w3.org/TR/xmlschema-1/#xsi_schemaLocation

.Link
	https://docs.microsoft.com/dotnet/api/system.xml.xmlresolver

.Link
	https://docs.microsoft.com/dotnet/api/system.xml.schema.validationeventhandler

.Link
	Resolve-XmlSchemaLocation.ps1

.Example
	Test-Xml.ps1 '</>'

	False
#>

[CmdletBinding()][OutputType([bool])] Param(
[Parameter(ParameterSetName='Xml',Position=0,Mandatory=$true,ValueFromPipeline=$true)]
[ValidateScript({!(Test-Path $_ -PathType Leaf)})][string] $Xml,
[Parameter(ParameterSetName='Path',Mandatory=$true,ValueFromPipeline=$true)]
[ValidateScript({Test-Path $_ -PathType Leaf})][string] $Path,
[Alias('Schemas')][hashtable] $Schemata,
[switch]$Warnings,
[switch]$ErrorMessage
)
if($Path){$Xml= Get-Content $Path -Raw}
try{[xml]$x = $Xml}
catch [Management.Automation.RuntimeException]
{
	if($Warnings) {Write-Warning $_.Exception.Message}
	if(!$ErrorMessage) {return $false}
	else{return $_.Exception.InnerException.InnerException.Message}
}
#$x.Schemas.XmlResolver = New-Object Xml.XmlUrlResolver # this should be the default, but can't set a base URL
[Environment]::CurrentDirectory = $PWD # kludgy hack to try and address XmlUrlResolver using env working dir
$xmlsrc = if($Path) {@{Path=$Path}} else {@{Xml=$Xml}}
foreach($schema in Resolve-XmlSchemaLocation.ps1 @xmlsrc) {if($schema.Url){[void]$x.Schemas.Add($schema.Urn,$schema.Url)}}
if($Schemata) {foreach($schema in $Schemata.GetEnumerator()) {[void]$x.Schemas.Add($schema.Key,$schema.Value)}}
$x.Schemas.Schemas().SourceUri |% {Write-Verbose "Added schema $_"}
$Script:validationErrors = @()
$Script:warn = $Warnings
$x.Validate({ if($Script:warn) {Write-Warning $_.Message}; $Script:validationErrors += @($_.Message) })
if($ErrorMessage -and $Script:validationErrors) {return $Script:validationErrors}
elseif($Script:validationErrors) {return $false}
else {return $true}
