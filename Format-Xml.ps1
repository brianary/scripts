<#
.Synopsis
    Pretty-print XML.

.Parameter Xml
    The XML string or document to format.
#>

[CmdletBinding()] Param([Parameter(Position=0,Mandatory=$true)][xml]$Xml)
$Xml.Save([Console]::Out)