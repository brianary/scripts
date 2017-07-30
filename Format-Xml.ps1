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

.Inputs
    System.Xml.XmlDocument to serialize.

.Outputs
    System.String containing the serialized XML document with desired indents.

.Example
    ls README.md |ConvertTo-Xml |Format-Xml.ps1

    <Objects>
      <Object Type="System.IO.FileInfo">
        <Property Name="PSPath" Type="System.String">Microsoft.PowerShell.Core\FileSystem::C:\Users\brian\OneDrive\Documents\GitHub\scripts\README.md</Property>
        <Property Name="PSParentPath" Type="System.String">Microsoft.PowerShell.Core\FileSystem::C:\Users\brian\OneDrive\Documents\GitHub\scripts</Property>
        <Property Name="PSChildName" Type="System.String">README.md</Property>
        <Property Name="PSDrive" Type="System.Management.Automation.PSDriveInfo">C</Property>
        <Property Name="PSProvider" Type="System.Management.Automation.ProviderInfo">Microsoft.PowerShell.Core\FileSystem</Property>
        <Property Name="PSIsContainer" Type="System.Boolean">False</Property>
        <Property Name="Mode" Type="System.String">-a----</Property>
        <Property Name="VersionInfo" Type="System.Diagnostics.FileVersionInfo">File:             C:\Users\brian\OneDrive\Documents\GitHub\scripts\README.md
      InternalName:     
      OriginalFilename: 
      FileVersion:      
      FileDescription:  
      Product:          
      ProductVersion:   
      Debug:            False
      Patched:          False
      PreRelease:       False
      PrivateBuild:     False
      SpecialBuild:     False
      Language:         
      </Property>
        <Property Name="BaseName" Type="System.String">README</Property>
        <Property Name="Target" Type="System.Collections.Generic.List`1[System.String]" />
        <Property Name="LinkType" Type="System.String" />
        <Property Name="Name" Type="System.String">README.md</Property>
        <Property Name="Length" Type="System.Int64">10036</Property>
        <Property Name="DirectoryName" Type="System.String">C:\Users\brian\OneDrive\Documents\GitHub\scripts</Property>
        <Property Name="Directory" Type="System.IO.DirectoryInfo">C:\Users\brian\OneDrive\Documents\GitHub\scripts</Property>
        <Property Name="IsReadOnly" Type="System.Boolean">False</Property>
        <Property Name="Exists" Type="System.Boolean">True</Property>
        <Property Name="FullName" Type="System.String">C:\Users\brian\OneDrive\Documents\GitHub\scripts\README.md</Property>
        <Property Name="Extension" Type="System.String">.md</Property>
        <Property Name="CreationTime" Type="System.DateTime">2017-02-03 22:26:47</Property>
        <Property Name="CreationTimeUtc" Type="System.DateTime">2017-02-04 06:26:47</Property>
        <Property Name="LastAccessTime" Type="System.DateTime">2017-07-30 09:51:27</Property>
        <Property Name="LastAccessTimeUtc" Type="System.DateTime">2017-07-30 16:51:27</Property>
        <Property Name="LastWriteTime" Type="System.DateTime">2017-07-29 23:35:01</Property>
        <Property Name="LastWriteTimeUtc" Type="System.DateTime">2017-07-30 06:35:01</Property>
        <Property Name="Attributes" Type="System.IO.FileAttributes">Archive</Property>
      </Object>
    </Objects>
#>

[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][xml]$Xml,
[ValidatePattern('\s')][char]$IndentChar = ' ',
[int]$Indentation = 2
)
Process
{
    [Xml.XmlWriterSettings] $cfg = New-Object Xml.XmlWriterSettings -Property @{
        Indent             = !!$Indentation
        IndentChars        = "$IndentChar" * $Indentation
        OmitXmlDeclaration = $true
    }
    $sw = New-Object IO.StringWriter
    [Xml.XmlWriter] $xw = [Xml.XmlWriter]::Create($sw, $cfg)
    $Xml.WriteTo($xw)
    $xw.Dispose()
    $sw.ToString()
    $sw.Dispose()
}
