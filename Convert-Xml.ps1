<#
.SYNOPSIS
Transform XML using an XSLT template.

.FUNCTIONALITY
XML

.EXAMPLE
Convert-Xml.ps1 '<a xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>' '<z/>' |Format-Xml.ps1

<a />

.EXAMPLE
Convert-Xml.ps1 -TransformFile xsd2html.xslt -Path schema.xsd -OutFile schema.html

Writes schema.html by applying the xsd2html.xslt transformation to schema.xsd.
#>

#Requires -Version 3
#Requires -Modules SelectXmlExtensions
[CmdletBinding(SupportsShouldProcess=$true)]
[OutputType(ParameterSetName='Xml',[void])][OutputType(ParameterSetName='File',[void])] Param(
# An XML document containing an XSLT transform.
[Parameter(ParameterSetName='Xml',Position=0,Mandatory=$true)][xml] $TransformXslt,
# An XML document to transform.
[Parameter(ParameterSetName='Xml',Position=1,ValueFromPipeline=$true)][xml] $Xml,
# The XSLT file to use to transform the XML.
[Parameter(ParameterSetName='File',Mandatory=$true)][Alias('TemplateFile','XsltTemplateFile')][string] $TransformFile,
# The XML file to transform.
[Parameter(ParameterSetName='File',ValueFromPipelineByPropertyName=$true)][Alias('XmlFile','FullName')][string] $Path,
# The file to write the transformed XML to.
[Parameter()][string] $OutFile,
<#
When specified, indicates the XSLT is trusted, enabling the document()
function and embedded script blocks.
#>
[switch] $TrustedXslt
)
Begin
{
	if($PSCmdlet.ParameterSetName -eq 'File')
	{
		[xml] $TransformXslt = Resolve-Path $TransformFile |Get-Content -Raw
		[xml] $Xml = Resolve-Path $Path |Get-Content -Raw
	}
	[version] $xsltversion = Select-Xml '/*/@version' $TransformXslt -Namespace @{
			xsl='http://www.w3.org/1999/XSL/Transform'} |Get-XmlValue
	if($xsltversion -gt '1.0')
	{ Stop-ThrowError.ps1 "XSLT version $xsltversion is not supported by the CLR." -Argument TransformFile }
	$xslt = New-Object Xml.Xsl.XslCompiledTransform
	try
	{
		$xslt.Load($TransformXslt,
			$(if($TrustedXslt) {[Xml.Xsl.XsltSettings]::TrustedXslt}else {[Xml.Xsl.XsltSettings]::Default}),
			(New-Object Xml.XmlUrlResolver -Property @{Credentials = [Net.CredentialCache]::DefaultCredentials}))
	}
	catch [Management.Automation.MethodInvocationException]
	{
		for($ex = $_.Exception.InnerException; $ex; $ex = $ex.InnerException) {Write-Error $ex.Message}
		throw
	}
}
Process
{
	if($PSCmdlet.ParameterSetName -eq 'File') {[xml] $Xml = Resolve-Path $Path |Get-Content -Raw}
	if(!$OutFile)
	{
		$ms = New-Object IO.MemoryStream
		$xw = [Xml.XmlWriter]::Create($ms,$xslt.OutputSettings)
		$xslt.Transform($Xml,$xw)
		$xw.Close() ; $xw.Dispose() ; $xw = $null
		[void]$ms.Seek(0,0)
		$result = New-Object xml
		$result.Load($ms)
		$ms.Close() ; $ms.Dispose() ; $ms = $null
		$result
	}
	else
	{
		$absOutFile = [IO.Path]::Combine($PWD,$OutFile)
		if((Test-Path $absOutFile) -and
			!$PSCmdlet.ShouldContinue("$(Get-Item $absOutFile |Select-Object FullName,LastWriteTime,Length)","Overwrite File?"))
		{Write-Warning "Skipping transform from $absPath to $OutFile"; return}
		$sw = New-Object IO.StreamWriter $absOutFile
		$xslt.Transform([Xml.XPath.IXPathNavigable]$Xml,(New-Object Xml.XmlTextWriter $sw))
		$sw.Close() ; $sw.Dispose() ; $sw = $null
	}
}

