<#
.Synopsis
	Transform XML using an XSLT template.

.Parameter TransformXslt
	An XML document containing an XSLT transform.

.Parameter Xml
	An XML document to transform.

.Parameter TransformFile
	The XSLT file to use to transform the XML.

.Parameter Path
	The XML file to transform.

.Parameter OutFile
	The file to write the transformed XML to.

.Parameter TrustedXslt
	When specified, indicates the XSLT is trusted, enabling the document()
	function and embedded script blocks.

.Example
	Convert-Xml.ps1 '<a xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>' '<z/>' |Format-Xml.ps1

	<a />

.Example
	Convert-Xml.ps1 xsd2html.xslt schema.xsd schema.html

	(Writes schema.html)
#>

[CmdletBinding(SupportsShouldProcess=$true)]
[OutputType(ParameterSetName='Xml',[void])][OutputType(ParameterSetName='File',[void])] Param(
[Parameter(ParameterSetName='Xml',Position=0,Mandatory=$true)][xml] $TransformXslt,
[Parameter(ParameterSetName='Xml',Position=1,ValueFromPipeline=$true)][xml] $Xml,
[Parameter(ParameterSetName='File',Mandatory=$true)][Alias('TemplateFile','XsltTemplateFile')][string] $TransformFile,
[Parameter(ParameterSetName='File',ValueFromPipelineByPropertyName=$true)][Alias('XmlFile','FullName')][string] $Path,
[Parameter()][string] $OutFile,
[switch] $TrustedXslt
)
Begin
{
	if($PSCmdlet.ParameterSetName -eq 'File') {[xml] $TransformXslt = Resolve-Path $TransformFile |Get-Content -Raw}
	[version] $xsltversion = Select-Xml '/*/@version' $TransformXslt -Namespace @{
			xsl='http://www.w3.org/1999/XSL/Transform'} |Select-XmlNodeValue.ps1
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
			!$PSCmdlet.ShouldContinue("$(Get-Item $absOutFile |select FullName,LastWriteTime,Length)","Overwrite File?"))
		{Write-Warning "Skipping transform from $absPath to $OutFile"; return}
		$sw = New-Object IO.StreamWriter $absOutFile
		$xslt.Transform($Xml,$sw)
		$sw.Close() ; $sw.Dispose() ; $sw = $null
	}
}
