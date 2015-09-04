<#
.Synopsis
    Pretty-print XML.

.Parameter Xml
    The XML string or document to format.

.Parameter IndentChar
    A whitespace indent character to use, space by default.

.Parameter Indentation
    The number of IndentChars to use per level of indent, 2 by default.
    Set to zero for no indentation.
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][xml]$Xml,
[ValidatePattern('\s')][char]$IndentChar = ' ',
[int]$Indentation = 2
)
$ms = New-Object IO.MemoryStream
$xw = New-Object Xml.XmlTextWriter $ms,(New-Object Text.UTF8Encoding $false)
$xw.Formatting = 
    if($Indentation) {'Indented'}
    else {'None'}
$xw.Indentation = $Indentation
$xw.IndentChar = $IndentChar
[void]$Xml.WriteTo($xw)
[void]$xw.Flush()
[Text.Encoding]::UTF8.GetString($ms.ToArray())
[void]$xw.Dispose() ; $xw = $null
[void]$ms.Dispose() ; $ms = $null
