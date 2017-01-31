<#
.Synopsis
    Display an HTML view of an XML schema or WSDL using Saxon.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][string]$SchemaFile
)
Begin { Use-Command.ps1 saxon 'C:\Program Files\Saxonica\Saxon*\bin\Transform.exe' -nupkg saxon-he -InstallDir 'C:\Program Files\Saxonica' }
Process
{
    $css  = Join-Path $PSScriptRoot 'dataref.css'
    $xslt = Join-Path $PSScriptRoot 'dataref.xslt'
    $html = [IO.Path]::ChangeExtension($SchemaFile,'html')
    Copy-Item $css .
    saxon -s:$SchemaFile -xsl:$xslt -o:$html
    Invoke-Item $html
}