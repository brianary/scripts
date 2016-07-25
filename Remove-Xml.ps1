<#
.Synopsis
    Removes a node specified by XPath from an XML file.

.Parameter XPath
    An XPath expression that specifies the node to remove.

.Parameter Path
    The XML file to modify.

.Example
    Remove-Xml.ps1 '/configuration/appSettings/add[@name="Version"]' app.config
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string]$XPath,
[Parameter(Position=1,Mandatory=$true)][string]$Path
)
$node = Select-Xml $XPath $Path |% Node
if(!$node) { Write-Verbose "XPath $XPath not found in $Path" ; return }
Write-Verbose "Found $XPath in Path $Path"
Write-Verbose "Removing $($node.OuterXml)"
$xw = New-Object Xml.XmlTextWriter (Resolve-Path $Path |% Path),([Text.Encoding]::UTF8)
$node.ParentNode.RemoveChild($node).OwnerDocument.Save($xw)
$xw.Dispose()
$xw = $null
