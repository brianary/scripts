<#
.SYNOPSIS
Parse escaped XML into XML and serialize it.

.INPUTS
System.String, some escaped XML.

.FUNCTIONALITY
XML

.OUTPUTS
System.String, the XML parsed and serialized.

.EXAMPLE
ConvertFrom-EscapedXml.ps1 '&lt;a href=&quot;http://example.org&quot;&gt;link&lt;/a&gt;'

<a href="http://example.org">link</a>
#>

#Requires -Version 2
[CmdletBinding()][OutputType([string])] Param(
# The escaped XML text.
[Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)][string] $EscapedXml,
# Outputs the XML without indentation.
[Alias('NoIndent')][switch] $Compress
)
Process
{
	[xml] $xml = [Net.WebUtility]::HtmlDecode($EscapedXml)
	$sw = New-Object IO.StringWriter
	[Xml.XmlWriterSettings] $cfg = New-Object Xml.XmlWriterSettings -Property @{ Indent = !$Compress; OmitXmlDeclaration = $true }
	[Xml.XmlWriter] $xo = [Xml.XmlWriter]::Create($sw, $cfg)
	$xml.WriteTo($xo)
	$xo.Dispose()
	$out = $sw.ToString()
	$sw.Dispose()
	return $out
}
