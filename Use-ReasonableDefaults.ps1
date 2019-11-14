<#
.Synopsis
    Sets certain cmdlet parameter defaults to rational, useful values.

.Example
    Use-ReasonableDefaults.ps1

    Sets the security protocol to TLS 1.2.

    Sets default values:
        Out-File -Encoding UTF8 -Width ([int]::MaxValue)
        Export-Csv -NoTypeInformation
        Invoke-WebRequest -UseBasicParsing
        Select-Xml -Namespace @{ a bunch of standard namespaces }
#>

#Requires -Version 3
[CmdletBinding()] Param()
[Net.ServicePointManager]::SecurityProtocol = 'Tls12'
$Global:PSDefaultParameterValues['Out-File:Width'] = [int]::MaxValue
$Global:PSDefaultParameterValues['Out-File:Encoding'] = 'UTF8'
$Global:PSDefaultParameterValues['Get-ChildItem:Force'] = $True
$Global:PSDefaultParameterValues['Export-Csv:NoTypeInformation'] = $True
$Global:PSDefaultParameterValues['Invoke-WebRequest:UseBasicParsing'] = $True
$Global:PSDefaultParameterValues['Select-Xml:Namespace'] = @{
xhtml    = 'http://www.w3.org/1999/xhtml'
svg      = 'http://www.w3.org/2000/svg'
xsl      = 'http://www.w3.org/1999/XSL/Transform'
fn       = 'http://www.w3.org/2005/xpath-functions'
xs       = 'http://www.w3.org/2001/XMLSchema'
wsdl     = 'http://schemas.xmlsoap.org/wsdl/'
err      = 'http://www.w3.org/2005/xqt-errors'
atom     = 'http://www.w3.org/2005/Atom'
rss      = 'http://purl.org/rss/1.0/'
rdf      = 'http://www.w3.org/1999/02/22-rdf-syntax-ns'
rdfs     = 'http://www.w3.org/2000/01/rdf-schema'
xsd      = 'http://www.w3.org/2001/XMLSchema'
msb      = 'http://schemas.microsoft.com/developer/msbuild/2003'
owl      = 'http://www.w3.org/2002/07/owl'
dc       = 'http://purl.org/dc/terms/'
cc       = 'http://creativecommons.org/ns#'
foaf     = 'http://xmlns.com/foaf/0.1/'
vcard    = 'http://www.w3.org/2006/vcard/ns'
dbp      = 'http://dbpedia.org/dbprop/'
geo      = 'http://www.geonames.org/ontology'
gr       = 'http://purl.org/goodrelations/v1'
media    = 'http://search.yahoo.com/searchmonkey/media/'
cb       = 'http://cb.semsol.org/ns'
ps       = 'http://schemas.microsoft.com/powershell/2004/04'
task     = 'http://schemas.microsoft.com/windows/2004/02/mit/task'
bcp      = 'http://schemas.microsoft.com/sqlserver/2004/bulkload/format'
xsi      = 'http://www.w3.org/2001/XMLSchema-instance'
m        = 'http://schemas.microsoft.com/ado/2007/08/dataservices/metadata' # SharePoint
maml     = 'http://schemas.microsoft.com/maml/2004/10'             # PowerShell binary module help format (psbinmod help)
cmd      = 'http://schemas.microsoft.com/maml/dev/command/2004/10' # psbinmod help
dev      = 'http://schemas.microsoft.com/maml/dev/2004/10'         # psbinmod help
MSHelp   = 'http://msdn.microsoft.com/mshelp'                      # psbinmod help
msxsl    = 'urn:schemas-microsoft-com:xslt'
z        = '#RowsetSchema' # https://docs.microsoft.com/sql/ado/guide/data/namespaces#remarks
s        = 'uuid:BDC6E3F0-6DA3-11d1-A2A3-00AA00C14882'
dt       = 'uuid:C2F41010-65B3-11d1-A29F-00AA00C14882'
rs       = 'urn:schemas-microsoft-com:rowset'
sodipodi = 'http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd'
inkscape = 'http://www.inkscape.org/namespaces/inkscape'
}
