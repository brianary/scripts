<#
.SYNOPSIS
Sets a secret in a secret vault with metadata.

.FUNCTIONALITY
Git and GitHub

.EXAMPLE
Save-Secret.ps1 GitHubToken -Paste securestring -Title 'PowerShell token' -Description 'A GitHub classic token' -Url https://github.com/settings/tokens -Expires (Get-Date).AddDays(90)

Stores the token from the clipboard.
#>

#Requires -Version 7
#Requires -Modules Microsoft.PowerShell.SecretManagement,Microsoft.PowerShell.SecretStore
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string] $Name,
[Parameter(ParameterSetName='Secret',Position=1,Mandatory=$true)][securestring] $Secret,
[string] $Title,
[string] $Description,
[string] $Note,
[uri] $Uri,
[datetime] $Created = (Get-Date),
[datetime] $Expires,
[Parameter(ParameterSetName='Paste',Mandatory=$true)]
[ValidateSet('string','securestring','bytes','hexbytes')][string] $Paste,
[Parameter(ParameterSetName='PasteForUser',Mandatory=$true)][string] $PasteForUser,
[Parameter(ParameterSetName='PasteTextBytes',Mandatory=$true)][Text.Encoding] $PasteTextBytes
)
$clipboard = Get-Clipboard |Out-String
$value = switch($PSCmdlet.ParameterSetName)
{
    PasteForUser {New-Object pscredential $PasteForUser,($clipboard |ConvertTo-SecureString -AsPlainText -Force)}
    PasteTextBytes {$PasteTextBytes.GetBytes($clipboard)}
    Secret {$Secret}
    Paste 
    {
        switch($Paste)
        {
            string {$clipboard}
            securestring {$clipboard |ConvertTo-SecureString -AsPlainText -Force}
            bytes {[byte[]]($clipboard -split '\D+')}
            hexbytes {
                $clipboard = $clipboard -replace '[^A-Fa-f0-9]+'
                $bytes = [bigint]::Parse("00$clipboard",'HexNumber').ToByteArray()
                [array]::Reverse($bytes)
                $null,$bytes = $bytes
                $bytes
            }
        }
    }
}
$metadata = @{ Created = $Created }
if($Title) {$metadata['Title'] = $Title}
if($Description) {$metadata['Description'] = $Description}
if($Note) {$metadata['Note'] = $Note}
if($Uri) {$metadata['Uri'] = "$Uri"}
if($Expires) {$metadata['Expires'] = $Expires}
Set-Secret $Name $value -Metadata $metadata
