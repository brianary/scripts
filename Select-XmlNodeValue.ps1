<#
.Synopsis
    Returns the node value in XML using a given XPath expression.

.Parameter XPath
    Specifies an XPath search query. The query language is case-sensitive. This parameter is required.

.Parameter Xml
    Specifies one or more XML nodes.
    An XML document will be processed as a collection of XML nodes. If you pipe an XML document to Select-Xml, 
    each document node will be searched separately as it comes through the pipeline.

.Parameter Content
    Specifies a string that contains the XML to search. You can also pipe strings to Select-Xml.

.Parameter LiteralPath
    Specifies the paths and file names of the XML files to search. Unlike Path, the value of the LiteralPath 
    parameter is used exactly as it is typed. No characters are interpreted as wildcards. 
    If the path includes escape characters, enclose it in single quotation marks.
    Single quotation marks tell Windows PowerShell not to interpret any characters as escape sequences.

.Parameter Path
    Specifies the path and file names of the XML files to search. Wildcard characters are permitted.

.Parameter Namespace
    Specifies a hash table of the namespaces used in the XML. Use the format @{<namespaceName> = <namespaceValue>}.

.Parameter Text
    Return the node's #text property, rather than it's Value property.

.Example
    Select-XmlNodeValue /error/@message \\server\apps\appname\App_Data\Elmah.Errors\guid.xml 
    Object reference not set to an instance of an object.

.Example
    Select-XmlNodeValue //xs:element/@name schema.xsd -Namespace @{ xs = 'http://www.w3.org/2001/XMLSchema' }
    elementName1
    elementName2
    …
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string]$XPath,
[Parameter(ParameterSetName='Xml',ValueFromPipeline=$true,Position=1,Mandatory=$true)][Xml.XmlNode[]]$Xml,
[Parameter(ParameterSetName='Content',ValueFromPipeline=$true,Mandatory=$true)][string[]]$Content,
[Parameter(ParameterSetName='LiteralPath',Mandatory=$true)][string[]]$LiteralPath,
[Parameter(ParameterSetName='Path',Position=1,Mandatory=$true)][string[]]$Path,
[Hashtable]$Namespace,
[switch]$Text
)
$Param = @{ XPath = $XPath }
if($Namespace) { $Param.Add('Namespace',$Namespace) }
if($Xml) { $Param.Add('Xml',$Xml) }
elseif($Content) { $Param.Add('Content',$Content) }
elseif($LiteralPath) { $Param.Add('LiteralPath',$LiteralPath) }
elseif($Path) { $Param.Add('Path',$Path) }
if($Text) { Select-Xml @Param |% {$_.Node.'#text'} }
else { Select-Xml @Param |% {$_.Node.Value} }
