<#
.SYNOPSIS
Returns true if the difference file is newer than the reference file.

.OUTPUTS
System.Boolean indicating the difference file is newer.

.FUNCTIONALITY
Files
#>

#requires -version 3
[CmdletBinding()][OutputType([bool])] Param(
# One of two files to compare.
[Parameter(Position=0)][IO.FileInfo]$ReferenceFile,
# Another of two files to compare.
[Parameter(Position=1)][IO.FileInfo]$DifferenceFile
)

Write-Verbose "Comparing ReferenceFile: $ReferenceFile & DifferenceFile: $DifferenceFile"
if(!$ReferenceFile -or !$ReferenceFile.Exists) {Write-Verbose 'Reference file does not exist.'; return $DifferenceFile.Exists}
if(!$DifferenceFile -or !$DifferenceFile.Exists) {Write-Verbose 'Difference file does not exist.'; return $false}
if($ReferenceFile.VersionInfo.FileVersionRaw -lt $DifferenceFile.VersionInfo.FileVersionRaw)
{Write-Verbose "Newer file version: $($ReferenceFile.VersionInfo.FileVersionRaw) < $($DifferenceFile.VersionInfo.FileVersionRaw)"; return $true}
elseif($ReferenceFile.VersionInfo.FileVersionRaw -gt $DifferenceFile.VersionInfo.FileVersionRaw)
{Write-Verbose "Older file version: $($ReferenceFile.VersionInfo.FileVersionRaw) > $($DifferenceFile.VersionInfo.FileVersionRaw)"; return $false}
if($ReferenceFile.VersionInfo.ProductVersionRaw -lt $DifferenceFile.VersionInfo.ProductVersionRaw)
{Write-Verbose "Newer product version: $($ReferenceFile.VersionInfo.ProductVersionRaw) < $($DifferenceFile.VersionInfo.ProductVersionRaw)"; return $true}
elseif($ReferenceFile.VersionInfo.ProductVersionRaw -gt $DifferenceFile.VersionInfo.ProductVersionRaw)
{Write-Verbose "Older product version: $($ReferenceFile.VersionInfo.ProductVersionRaw) > $($DifferenceFile.VersionInfo.ProductVersionRaw)"; return $false}
if($ReferenceFile.LinkType -and $DifferenceFile.LinkType)
{
    $targets = [string[]]$ReferenceFile.Target + [string[]]$DifferenceFile.Target
    if($targets -and ($targets -icontains $ReferenceFile.FullName -or $target -icontains $DifferenceFile.FullName))
    {Write-Verbose 'Shared hardlink targets.'; return $false}
}
if($ReferenceFile.Length -eq $DifferenceFile.Length)
{
	$readbytes =
		if((Get-Command Get-Content).Parameters.Encoding.ParameterType -eq [Text.Encoding]) {@{AsByteStream=$true}}
		else {@{Encoding='Byte'}}
    if(Get-Command -Verb Get -Noun FileHash) {if((Get-FileHash $ReferenceFile).Hash -eq (Get-FileHash $DifferenceFile).Hash)
    {Write-Verbose 'Identical hash values.'; return $false}}
    elseif(!(compare (Get-Content $ReferenceFile @readbytes) (Get-Content $DifferenceFile @readbytes)))
    {Write-Verbose 'Identical contents.'; return $false}
}
if($ReferenceFile.LastWriteTimeUtc -lt $DifferenceFile.LastWriteTimeUtc)
{Write-Verbose "Newer date: $($ReferenceFile.LastWriteTimeUtc) < $($DifferenceFile.LastWriteTimeUtc)"; return $true}
Write-Verbose 'Inconclusive.'
return $false
