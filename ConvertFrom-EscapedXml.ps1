<#
.Synopsis
    Parse escaped XML into XML and serialize it.

.Parameter EscapedXml
    The escaped XML text.

.Parameter NoIndent
    Outputs the XML without indentation.

.Inputs
    System.String, some escaped XML.

.Outputs
    System.String, the XML parsed and serialized.

.Example
    ConvertFrom-EscapedXml.ps1 '&lt;a href=&quot;http://example.org&quot;&gt;link&lt;/a&gt;'

    <a href="http://example.org">link</a>
#>

#Requires -Version 2
[CmdletBinding()][OutputType([string])] Param(
[Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)][string]$EscapedXml,
[Alias('NoIndent')][switch]$Compress
)
[xml] $xml = [Net.WebUtility]::HtmlDecode($EscapedXml)
$sw = New-Object IO.StringWriter
[Xml.XmlWriterSettings] $saveopts = New-Object Xml.XmlWriterSettings -Property @{ Indent = !$Compress; OmitXmlDeclaration = $true }
[Xml.XmlWriter] $xo = [Xml.XmlWriter]::Create($sw, $saveopts)
$xml.WriteTo($xo)
$xo.Dispose()
$out = $sw.ToString()
$sw.Dispose()
$out
