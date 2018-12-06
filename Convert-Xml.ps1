<#
.Synopsis
    Transform XML using an XSLT template.

.Parameter TransformFile
    The XSLT file to use to transform the XML.

.Parameter Path
    The XML file to transform.

.Parameter OutFile
    The file to write the transformed XML to.

.Parameter TrustedXslt
    When specified, indicates the XSLT is trusted, enabling the document()
    function and embedded script blocks.

.Example
    Convert-Xml.ps1 xsd2html.xslt schema.xsd schema.html

    (Writes schema.html)
#>

[CmdletBinding(SupportsShouldProcess=$true)]Param(
[Parameter(Position=0,Mandatory=$true)][Alias('TemplateFile','XsltTemplateFile')][string]$TransformFile,
[Parameter(Position=1,ValueFromPipelineByPropertyName=$true)][Alias('XmlFile','FullName')][string]$Path,
[Parameter(Position=2)][string]$OutFile,
[switch]$TrustedXslt
)
Begin
{
    $xslt = New-Object Xml.Xsl.XslCompiledTransform
    try
    {
        $xslt.Load((Resolve-Path $TransformFile),
            $(if($TrustedXslt) {[Xml.Xsl.XsltSettings]::TrustedXslt}else {[Xml.Xsl.XsltSettings]::Default}),
            (New-Object Xml.XmlUrlResolver -Property @{Credentials = [Net.CredentialCache]::DefaultCredentials}))
    }
    catch [Management.Automation.MethodInvocationException]
    {
        for($ex = $_.Exception.InnerException; $ex; $ex = $ex.InnerException) {Write-Error $ex.Message}
        throw
    }
}
Process
{
    $absPath = Resolve-Path $Path
    if((Test-Path $OutFile) -and
        !$PSCmdlet.ShouldContinue("$(Get-Item $OutFile |select FullName,LastWriteTime,Length)","Overwrite File?"))
    {Write-Warning "Skipping transform from $absPath to $OutFile"; continue}
    if($OutFile) {$xslt.Transform($absPath,[IO.Path]::Combine($PWD,$OutFile))}
    else {$xslt.Transform($absPath,[Console]::Out)}
}
