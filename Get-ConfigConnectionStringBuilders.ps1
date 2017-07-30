<#
.Synopsis
    Return named connection string builders for connection strings in a config file.

.Parameter Path
    The .NET config file containing connection strings.

.Inputs
    System.String of the path to a .NET config file with connection strings.

.Outputs
    System.Management.Automation.PSObject with the Name and ConnectionString 
    (a ConnectionStringBuilder) for each connection string found.

.Link
    Select-Xml

.Example
    Get-ConfigConnectionStringBuilders.ps1 web.Debug.config

    Returns the connection strings found in the debug web.config XDT.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([psobject])] Param(
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true)][string]$Path
)
Process
{
    Select-Xml '//connectionStrings/add' $Path |
        % { 
            $provider = $_.Node.Attributes.GetNamedItem('providerName')
            if($provider){$provider=$provider.Value}
            New-Object psobject -Property ([ordered]@{
                Name = $_.Node.name
                ConnectionString = New-DbProviderObject.ps1 $provider ConnectionStringBuilder $_.Node.connectionString
            })
        }
}
