<#
.SYNOPSIS
Adds OuterXml, Value, XPath, and Namespace properties to Select-Xml output.
#>

#Requires -Version 3
#Requires -Modules @{ ModuleName = 'Microsoft.PowerShell.Utility'; RequiredVersion = '3.1.0.0' }
[CmdletBinding()][OutputType([Microsoft.PowerShell.Commands.SelectXmlInfo])] Param(
[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
[Microsoft.PowerShell.Commands.SelectXmlInfo]$SelectXmlInfo
)
Process
{
	$xpath = $SelectXmlInfo |Resolve-XPath.ps1
	$SelectXmlInfo |Add-Member XPath $xpath.XPath
	$SelectXmlInfo |Add-Member Namespace $xpath.Namespace
	$SelectXmlInfo |Add-Member OuterXml ($SelectXmlInfo.Node.OuterXml)
	$SelectXmlInfo |Add-Member Value ($SelectXmlInfo.Node.Value)
	return $SelectXmlInfo
}
