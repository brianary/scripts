<#
.Synopsis
	Try parsing text as XML, and validating it if a schema is provided.

.Parameter Path
	A file to check.

.Parameter Xml
	The string to check.

.Parameter Schemata
	A hashtable of schema namespaces to schema locations (in addition to the xsi:schemaLocation attribute).

.Parameter SkipValidation
	Indicates that XML Schema validation should not be performed, only XML well-formedness will be checked.

.Parameter Warning
	Indicates that well-formedness or validation errors will result in warnings being written.

.Parameter ErrorMessage
	When present, returns the well-formedness or validation error messages instead of a boolean value,
	or nothing if successful. This effectively reverses the truthiness of the return value.

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
	Test-Xml.ps1 -Xml '</>'

	False
#>

[CmdletBinding()][OutputType([bool])] Param(
[Parameter(ParameterSetName='Path',Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
[ValidateScript({Test-Path $_ -PathType Leaf})][Alias('FullName')][string] $Path,
[Parameter(ParameterSetName='Xml',Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
[ValidateScript({!(Test-Path $_ -PathType Leaf)})][string] $Xml,
[Alias('Schemas')][hashtable] $Schemata,
[Alias('NoValidation')][switch] $SkipValidation,
[Alias('ShowWarnings')][switch] $Warnings,
[Alias('NotSuccessful')][switch] $ErrorMessage
)
Begin
{
	function Add-Schema([Xml.Schema.XmlSchemaSet]$set,[string]$urn,[string]$url)
	{
		Write-Verbose "Adding $url for $urn"
		try {[void]$set.Add($urn,$url)}
		catch
		{
			if(!(Test-Path $url)) {Write-Error "Error adding $url for $urn"}
			else
			{
				$s = [Xml.Schema.XmlSchema]::Read( [IO.File]::OpenRead($url), {throw $_.Exception} )
				$s.Compile( {
					if($_.Severity -eq [Xml.Schema.XmlSeverityType]::Error) {Write-Error $_.Message; throw $_.Exception}
					else {Write-Warning $_.Message}
				} )
			}
		}
	}
}
Process
{
	if($Path){$Xml= Get-Content $Path -Raw}
	try{[xml]$x = $Xml}
	catch [Management.Automation.RuntimeException]
	{
		if($Warnings) {Write-Warning $_.Exception.Message}
		if(!$ErrorMessage) {return $false}
		else {return $_.Exception.InnerException.InnerException.Message}
	}
	if($SkipValidation) {return !$ErrorMessage}
	#$x.Schemas.XmlResolver = New-Object Xml.XmlUrlResolver # this should be the default, but can't set a base URL
	# kludgy hack to try and address XmlUrlResolver using env working dir:
	[Environment]::CurrentDirectory = if($Path) {Resolve-Path $Path |Split-Path} else {$PWD}
	$xmlsrc = if($Path) {@{Path=$Path}} else {@{Xml=$Xml}}
	foreach($schema in Resolve-XmlSchemaLocation.ps1 @xmlsrc |where {$_.Url}) {Add-Schema $x.Schemas $schema.Urn $schema.Url}
	if($Schemata) {foreach($schema in $Schemata.GetEnumerator()) {Add-Schema $x.Schemas $schema.Key $schema.Value}}
	if($x.Schemas.Count -eq 0) {return !$ErrorMessage}
	$x.Schemas.Schemas().SourceUri |% {Write-Verbose "Added schema $_"}
	$Script:validationErrors = @()
	$Script:warn = $Warnings
	$x.Validate({ if($Script:warn) {Write-Warning $_.Message}; $Script:validationErrors += @($_.Message) })
	if($ErrorMessage) {return $Script:validationErrors}
	else {return !($Script:validationErrors)}
}
