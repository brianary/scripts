<#
.SYNOPSIS
Sets a secret in a secret vault with metadata.

.FUNCTIONALITY
Credential

.EXAMPLE
Save-Secret.ps1 GitHubToken -Paste securestring -Title 'PowerShell token' -Description 'A GitHub classic token' -Url https://github.com/settings/tokens -Expires (Get-Date).AddDays(90)

Stores the token from the clipboard.
#>

#Requires -Version 7
#Requires -Modules Microsoft.PowerShell.SecretManagement,Microsoft.PowerShell.SecretStore
[CmdletBinding()] Param(
# Specifies the name of the secret to add metadata to. Wildcard characters (`*`) are not permitted.
[Parameter(Position=0,Mandatory=$true)][string] $Name,
# Specifies the value of the secret.
[Parameter(ParameterSetName='Secret',Position=1,Mandatory=$true)][securestring] $Secret,
# Specifies the value of the credential to store.
[Parameter(ParameterSetName='Credential',Position=1,Mandatory=$true)][pscredential] $Credential,
# Title metadata field.
[string] $Title,
# Description metadata field.
[string] $Description,
# Note metadata field.
[string] $Note,
# Uri metadata field.
[uri] $Uri,
# Created date/time metadata field.
[datetime] $Created = (Get-Date),
# Expiration date/time metadata field.
[datetime] $Expires,
# Specifies the type to interpret the text on the clipboard as for use as the secret value.
[Parameter(ParameterSetName='Paste',Mandatory=$true)]
[ValidateSet('string','securestring','bytes','hexbytes')][string] $Paste,
# Specifies the username to combine with the clipboard text as a password to store as a credential secret.
[Parameter(ParameterSetName='PasteForUser',Mandatory=$true)][string] $PasteForUser,
# Specifies the encoding to read the clipboard as, into a byte array secret.
[Parameter(ParameterSetName='PasteTextBytes',Mandatory=$true)][Text.Encoding] $PasteTextBytes
)
$clipboard = Get-Clipboard |Out-String
$value = switch($PSCmdlet.ParameterSetName)
{
    PasteForUser {New-Object pscredential $PasteForUser,($clipboard |ConvertTo-SecureString -AsPlainText -Force)}
    PasteTextBytes {$PasteTextBytes.GetBytes($clipboard)}
    Secret {$Secret}
    Credential {$Credential}
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
