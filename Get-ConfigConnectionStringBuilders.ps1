<#
.Synopsis
    Return named connection string builders for connection strings in a config file.

#>

#requires -version 3
[CmdletBinding()] Param(
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