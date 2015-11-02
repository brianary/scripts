<#
.Synopsis
    Returns true if the difference file is newer than the reference file.

.Parameter ReferenceFile
    One of two files to compare.

.Parameter DifferenceFile
    Another of two files to compare.
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][IO.FileInfo]$ReferenceFile,
[Parameter(Position=1,Mandatory=$true)][IO.FileInfo]$DifferenceFile
)

if(!($ReferenceFile.Exists)) {Write-Verbose 'Reference file does not exist.'; return $DifferenceFile.Exists}
if(!($DifferenceFile.Exists)) {Write-Verbose 'Difference file does not exist.'; return $false}
if($ReferenceFile.VersionInfo.FileVersionRaw -lt $DifferenceFile.VersionInfo.FileVersionRaw) {Write-Verbose 'Newer file version.'; return $true}
elseif($ReferenceFile.VersionInfo.FileVersionRaw -gt $DifferenceFile.VersionInfo.FileVersionRaw) {Write-Verbose 'Older file version.'; return $false}
if($ReferenceFile.VersionInfo.ProductVersionRaw -lt $DifferenceFile.VersionInfo.ProductVersionRaw) {Write-Verbose 'Newer product version.'; return $true}
elseif($ReferenceFile.VersionInfo.ProductVersionRaw -gt $DifferenceFile.VersionInfo.ProductVersionRaw) {Write-Verbose 'Older product version.'; return $false}
if($ReferenceFile.LinkType -and $DifferenceFile.LinkType)
{
    $targets = [string[]]$ReferenceFile.Target + [string[]]$DifferenceFile.Target
    if($targets -and ($targets -icontains $ReferenceFile.FullName -or $target -icontains $DifferenceFile.FullName))
    {Write-Verbose 'Shared hardlink targets.'; return $false}
}
if($ReferenceFile.Length -eq $DifferenceFile.Length)
{
    if(Get-Command -Verb Get -Noun FileHash) {if((Get-FileHash $ReferenceFile).Hash -eq (Get-FileHash $DifferenceFile).Hash)
    {Write-Verbose 'Identical hash values.'; return $false}}
    elseif(!(compare (Get-Content $ReferenceFile -Encoding Byte) (Get-Content $DifferenceFile -Encoding Byte)))
    {Write-Verbose 'Identical contents.'; return $false}
}
if($ReferenceFile.LastWriteTimeUtc -lt $DifferenceFile.LastWriteTimeUtc) {Write-Verbose 'Newer date.'; return $true}
Write-Verbose 'Inconclusive.'
return $false