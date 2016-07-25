<#
.Synopsis
    Insert XML into an XML file as a child of an XPath-specified node.

.Parameter Xml
    The XML to insert.

.Parameter XPath
    The XML file node to append the XML as a child of.

.Parameter Path
    The XML file to modify.

.Parameter UnlessXPath
    An XPath that will cancel the insert if it exists.
    Used to prevent inserting XML that already exists.

.Example
    Add-Xml.ps1 '<add name="Version" value="2.0"/>' '/configuration/appSettings' app.config '/configuration/appSettings/add[@name="Version"]'
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][xml]$Xml,
[Parameter(Position=1,Mandatory=$true)][string]$XPath,
[Parameter(Position=2,Mandatory=$true)][string]$Path,
[Parameter(Position=3)][Alias('IfMissing')][string]$UnlessXPath
)
if($UnlessXPath -and (Select-Xml $UnlessXPath $Path)) { Write-Verbose "Found $UnlessXPath in $Path" ; return }
Write-Verbose "XPath $UnlessXPath not found in file $Path"
$node = Select-Xml $XPath $Path |% Node
if(!$node) { Write-Error "Could not locate $XPath to append child" ; return }
Write-Verbose "Appending $($Xml.OuterXml) as child of $XPath in $Path"
$doc = $node.OwnerDocument
$xw = New-Object Xml.XmlTextWriter (Resolve-Path $Path |% Path),([Text.Encoding]::UTF8)
[void]$node.AppendChild($doc.CreateTextNode("`n"))
$node.AppendChild($doc.ImportNode($Xml.DocumentElement,$true)).OwnerDocument.Save($xw)
$xw.Dispose()
$xw = $null
