<#
.Synopsis
    Updates permissions on certs when there is an older cert with the same friendly name.

.Parameter Certificate
    X509Certificate2 to copy permissions between.

.Link
	https://docs.microsoft.com/dotnet/api/system.security.accesscontrol.filesystemaccessrule

.Link
	Format-Certificate.ps1

.Link
	Get-CertificatePermissions.ps1

.Link
	Get-CertificatePath.ps1

.Link
	Get-Acl

.Link
	Set-Acl

.Example
    Find-Certificate.ps1 subject.name FindBySubjectName TrustedPeople LocalMachine |Sync-NewCertificatePermissions.ps1

    Updates permissions on the newest certificate using the second newest as a template.
#>

#Requires -RunAsAdministrator
#Requires -Version 3
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromRemainingArguments=$true)]
[System.Security.Cryptography.X509Certificates.X509Certificate2[]] $Certificate
)
Begin { $certs = @() }
Process { $Certificate |foreach {$certs += $_} }
End
{
	# ignore untethered SIDs and inherited perms
	$isRelevant = { $(try { $_.IdentityReference.Translate([Security.Principal.NTAccount]).Value }catch { $false }) -and !$_.IsInherited }
	$toJsonRule = { "[$(($_.IdentityReference.Value |ConvertTo-Json),[int]$_.FileSystemRights,[int]$_.AccessControlType -join ',')]" }
	$newcert, $prevcert = $certs.Group |sort NotAfter -Descending
	$newcertname = Format-Certificate.ps1 $newcert
	[string[]] $prevperms = @(Get-CertificatePermissions.ps1 $prevcert |where $isRelevant |foreach $toJsonRule |sort)
	[string[]] $newperms = @(Get-CertificatePermissions.ps1 $newcert |where $isRelevant |foreach $toJsonRule |sort)
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
