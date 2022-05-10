<#
.SYNOPSIS
Updates permissions on certs when there is an older cert with the same friendly name.

.LINK
https://docs.microsoft.com/dotnet/api/system.security.accesscontrol.filesystemaccessrule

.LINK
Format-Certificate.ps1

.LINK
Get-CertificatePermissions.ps1

.LINK
Get-CertificatePath.ps1

.LINK
Get-Acl

.LINK
Set-Acl

.EXAMPLE
Find-Certificate.ps1 subject.name FindBySubjectName TrustedPeople LocalMachine |Sync-NewCertificatePermissions.ps1

Updates permissions on the newest certificate using the second newest as a template.
#>

#Requires -RunAsAdministrator
#Requires -Version 3
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')] Param(
# X509Certificate2 to copy permissions between.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromRemainingArguments=$true)]
[System.Security.Cryptography.X509Certificates.X509Certificate2[]] $Certificate
)
Begin
{
	filter Select-Relevant
	{ # ignore untethered SIDs and inherited perms
		try {if($_.IdentityReference.Translate([Security.Principal.NTAccount]).Value -and !$_.IsInherited) {return $_}}
		catch {}
	}

	filter ConvertTo-JsonRule
	{
		return "[$(($_.IdentityReference.Value |ConvertTo-Json),[int]$_.FileSystemRights,[int]$_.AccessControlType -join ',')]"
	}
}
End
{
	[System.Security.Cryptography.X509Certificates.X509Certificate2[]] $certs = $input.ForEach({$_}) # flatten nested arrays
	$newcert, $prevcert = $certs.Group |sort NotAfter -Descending
	$newcertname = Format-Certificate.ps1 $newcert
	[string[]] $prevperms = @(Get-CertificatePermissions.ps1 $prevcert |Select-Relevant |ConvertTo-JsonRule |sort)
	[string[]] $newperms = @(Get-CertificatePermissions.ps1 $newcert |Select-Relevant |ConvertTo-JsonRule |sort)
	$addperms = @()
	$removeperms = @()
	foreach ($diff in compare $prevperms $newperms)
	{
		$value = ConvertFrom-Json $diff.InputObject
		if ($diff.SideIndicator -eq '=>') { $removeperms += New-Object Security.AccessControl.FileSystemAccessRule $value }
		else { $addperms += New-Object Security.AccessControl.FileSystemAccessRule $value }
	}
	if (($addperms.Count -eq 0) -and ($removeperms.Count -eq 0)) { continue }
	$newcertpath = Get-CertificatePath.ps1 $newcert
	$acl = Get-Acl $newcertpath
	foreach ($perm in $addperms)
	{
		$who, $type, $rights = $perm.IdentityReference.Value, $perm.AccessControlType, $perm.FileSystemRights
		if (!$PSCmdlet.ShouldProcess($newcertname, "set $type $rights access for $who")) { continue }
		Write-Verbose "Setting $who $type $rights access to $newcertname"
		$acl.SetAccessRule($perm)
	}
	#TODO: remove $removeperms, conditionally after adding switch param $RemoveNewPerms
	Set-Acl $newcertpath $acl
}
