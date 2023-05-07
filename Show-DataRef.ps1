<#
.SYNOPSIS
Display an HTML view of an XML schema or WSDL using Saxon.

.FUNCTIONALITY
XML

.EXAMPLE
Show-DataRef.ps1 DataModel.xsd

(Renders the XML schema as HTML.)
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
# System.String containing the path to an XML Schema or WSDL file.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$SchemaFile
)
Begin
{
    Use-Command.ps1 saxon $env:ProgramFiles\Saxonica\Saxon*\bin\Transform.exe -nupkg saxon-he `
        -InstallDir $env:ProgramFiles\Saxonica
}
Process
{
    $css  = Join-Path $PSScriptRoot 'dataref.css'
    $xslt = Join-Path $PSScriptRoot 'dataref.xslt'
    $html = [IO.Path]::ChangeExtension($SchemaFile,'html')
    Copy-Item $css .
    C:\ProgramData\chocolatey\bin\SaxonHE\bin\Transform.exe -s:$SchemaFile -xsl:$xslt -o:$html
    Invoke-Item $html
}

