<#
.Synopsis
    Export SMB shares using old NET SHARE command, to new New-SmbShare PowerShell commands.

.Description
    This script is intended to be used to export shares from old machines to new ones.

.Example
    Export-SmbShares.ps1

    New-SmbShare -Name 'Data' -Path 'C:\Data' -ChangeAccess 'Everyone'
#>

#Requires -Version 3
[CmdletBinding()] Param()

function ConvertTo-StringLiteral([Parameter(ValueFromPipeline=$true)][string]$value)
{Process{"'$($value -replace '''','''''')'"}}

foreach($share in (Get-WmiObject Win32_Share))
{
    if($share.Name -match '(?i)\A(?:[a-z]|admin|ipc)\$$'){continue} # skip the builtins
    $perms = (net share $share.Name |Out-String) -replace 
        '(?ms)\A.*^Permission|(\r\n){2,}|^\b.*\r\n','' -replace '\A\s*|\s*\z','' -split '\r\n\s*'
    $access = @{}
    $perms |
        % {
            $user,$permission =  $_ -split ', (?=READ|CHANGE|FULL)\b'
            New-Object psobject -Property @{User=$user;Access=$permission}
        } |
        group Access |
        % {[void]$access.Add($_.Name,[string[]]($_.Group|% User))}
    $cmd = @(
        'New-SmbShare',
        '-Name',(ConvertTo-StringLiteral $share.Name),
        '-Path',(ConvertTo-StringLiteral $share.Path)
    )
    if($share.Description){$cmd+=@('-Description',(ConvertTo-StringLiteral $share.Description))}
    if($access.FULL){$cmd+=@('-FullAccess',(($access.FULL|ConvertTo-StringLiteral) -join ','))}
    if($access.CHANGE){$cmd+=@('-ChangeAccess',(($access.CHANGE|ConvertTo-StringLiteral) -join ','))}
    if($access.READ){$cmd+=@('-ReadAccess',(($access.READ|ConvertTo-StringLiteral) -join ','))}
    "$cmd"
}
