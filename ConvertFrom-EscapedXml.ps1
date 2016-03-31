<#
.Synopsis
    Parse escaped XML into XML and serialize it.

.Parameter EscapedXml
    The escaped XML text.

.Parameter NoIndent
    Outputs the XML without indentation.
#>

#request -version 2
[CmdletBinding()] Param(
[Parameter(Mandatory=$true,Position=0)][string]$EscapedXml,
[switch]$NoIndent
)
[xml] $xml = [Net.WebUtility]::HtmlDecode($EscapedXml)
$sw = New-Object IO.StringWriter
[Xml.XmlWriterSettings] $saveopts = New-Object Xml.XmlWriterSettings -Property @{ Indent = $true }
[Xml.XmlWriter] $xo = [Xml.XmlWriter]::Create($sw, $saveopts)
$xml.WriteTo($xo)
$xo.Dispose()
$out = $sw.ToString()
$sw.Dispose()
$out