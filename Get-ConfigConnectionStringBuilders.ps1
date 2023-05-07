<#
.SYNOPSIS
Return named connection string builders for connection strings in a config file.

.INPUTS
System.String of the path to a .NET config file with connection strings.

.OUTPUTS
System.Management.Automation.PSCustomObject with the Name and ConnectionString
(a ConnectionStringBuilder) for each connection string found.

.FUNCTIONALITY
Configuration

.LINK
Select-Xml

.EXAMPLE
Get-ConfigConnectionStringBuilders.ps1 web.Debug.config

Returns the connection strings found in the debug web.config XDT.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Management.Automation.PSCustomObject])] Param(
# The .NET config file containing connection strings.
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string]$Path
)
Process
{
    Select-Xml '//connectionStrings/add' $Path |
        ForEach-Object {
            $provider = $_.Node.Attributes.GetNamedItem('providerName')
            if($provider){$provider=$provider.Value}
            [pscustomobject]@{
                Name = $_.Node.name
                ConnectionString = New-DbProviderObject.ps1 $provider ConnectionStringBuilder $_.Node.connectionString
            }
        }
}

