<#
.SYNOPSIS
Export SMB shares using old NET SHARE command, to new New-SmbShare PowerShell commands.

.DESCRIPTION
This script is intended to be used to export shares from old machines to new ones.

.OUTPUTS
System.String[] of PowerShell commands to duplicate the local machine's shares.

.EXAMPLE
Export-SmbShares.ps1

New-SmbShare -Name 'Data' -Path 'C:\Data' -ChangeAccess 'Everyone'
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string[]])] Param(
# The name of a script file to export to.
[string]$Path = "Import-${env:ComputerName}SmbShares.ps1"
)

filter ConvertTo-StringLiteral {"'$($_ -replace '''','''''')'"}

function Export-SmbShares
{
	@"
<#
.SYNOPSIS
Imports SMB file shares exported from $env:ComputerName
#>

#Requires -Version 3
#Requires -RunAsAdministrator
[CmdletBinding(SupportsShouldProcess=`$true,ConfirmImpact='High')] Param()

"@
	foreach($share in (Get-CimInstance Win32_Share))
	{
		Write-Verbose "Found share: $($share.Name)"
		if($share.Name -match '(?i)\A(?:[a-z]|admin|ipc)\$$'){Write-Verbose '(skipping)'; continue} # skip the builtins
		$quotablename,$quotablepath = ($share.Name -replace "'","''"),($share.Path -replace "'","''")
		$perms = (net share $share.Name |Out-String) -replace
			'(?ms)\A.*^Permission|(\r\n){2,}|^\b.*\r\n','' -replace '\A\s*|\s*\z','' -split '\r\n\s*'
		$access = @{}
		$perms |
			% {
				$user,$permission =  $_ -split ', (?=READ|CHANGE|FULL)\b'
				[pscustomobject]@{User=$user;Access=$permission}
			} |
			group Access |
			% {[void]$access.Add($_.Name,[string[]]($_.Group|% User))}
		$cmd = @('New-SmbShare','-Name',"'$quotablename'",'-Path',"'$quotablepath'")
		if($share.Description){$cmd+=@('-Description',(ConvertTo-StringLiteral $share.Description))}
		if($access.ContainsKey('FULL')){$cmd+=@('-FullAccess',(($access.FULL|ConvertTo-StringLiteral) -join ','))}
		if($access.ContainsKey('CHANGE')){$cmd+=@('-ChangeAccess',(($access.CHANGE|ConvertTo-StringLiteral) -join ','))}
		if($access.ContainsKey('READ')){$cmd+=@('-ReadAccess',(($access.READ|ConvertTo-StringLiteral) -join ','))}
		Write-Verbose "Share command: $cmd"
		"if(Test-Path '$quotablepath' -PathType Container){$cmd}"
		"else{Write-Error 'Folder $quotablepath does not exist to share as $quotablename'}"
	}
}

Export-SmbShares |Out-File $Path utf8
Write-Verbose "Wrote import script to $Path"

