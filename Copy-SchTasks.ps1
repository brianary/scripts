<#
.SYNOPSIS
Copy scheduled jobs from another computer to this one, using a GUI list to choose jobs.

.FUNCTIONALITY
Scheduled Tasks

.EXAMPLE
Copy-SchTasks.ps1 SourceComputer DestComputer

Attempts to copy tasks from SourceComputer to DestComputer.
#>

#Requires -Version 2
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter','',
Justification='The parameter is used elsewhere.')]
[CmdletBinding()][OutputType([void])] Param(
# The name of the computer to copy jobs from.
[Parameter(Mandatory=$true,Position=0)][Alias('CN','Source')][string]$ComputerName,
# The name of the computer to copy jobs to (local computer by default).
[Parameter(Position=1)][Alias('To','Destination')][string]$DestinationComputerName = $env:COMPUTERNAME
)
$TempXml= [io.path]::GetTempFileName()
$CredentialCache = @{}
function Get-CachedCredentialFor([Parameter(Mandatory=$true,Position=0)][string]$UserName)
{
    if(!$CredentialCache.ContainsKey($UserName))
    { $CredentialCache.Add($UserName,(Get-Credential -Message "Enter credentials for $UserName tasks" -UserName $UserName)) }
    $CredentialCache[$UserName]
}
filter ConvertFrom-Credential
([Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)][PSCredential][Management.Automation.Credential()]$Credential)
{ return $Credential.Password |ConvertFrom-SecureString -AsPlainText }
schtasks /query /s $ComputerName /v /fo csv |
    ConvertFrom-Csv |
    Where-Object {$_.HostName -ne 'HostName'} |
    Out-GridView -PassThru -Title 'Select jobs to copy' |
    Select-Object TaskName,'Run As User' -Unique |
    ForEach-Object {
        schtasks /query /s $ComputerName /tn $_.TaskName /xml ONE |
            Out-File $TempXml unicode -Width ([int]::MaxValue)
        schtasks /create /s $DestinationComputerName /tn $_.TaskName /ru ($_.'Run As User') `
            /rp (Get-CachedCredentialFor $_.'Run As User' |ConvertFrom-Credential) /xml $TempXml
        Remove-Item $TempXml
    }
$CredentialCache.Clear()

