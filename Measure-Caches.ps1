<#
.SYNOPSIS
Returns a list of matching cache directories, and their sizes, sorted.

.NOTES
A shocking number of apps don't seem to know how the Windows folder structure
works, writing cache data into the user profile's Roaming folder, which gets
recopied at every logon, which is extremely wrong.

This script is primarily intended to show the scope of the problem, but can
be used to measure other folder matches.

.FUNCTIONALITY
Files

.LINK
Use-Command.ps1

.LINK
Format-ByteUnits.ps1

.EXAMPLE
Measure-Caches.ps1 |Format-Table -AutoSize

Path                                                                Size    DirectorySize DirectorySizeOnDisk
----                                                                ----    ------------- -------------------
c:\users\usernam\appdata\roaming\code\cachedextensionvsixs          669.3MB     701856767           701915136
c:\users\usernam\appdata\roaming\slack\service worker\cachestorage  444MB       465538811           469655552
c:\users\usernam\appdata\roaming\slack\cache                        340.2MB     356697780           357654528
c:\users\usernam\appdata\roaming\slack\cache\cache_data             340.2MB     356697780           357650432
c:\users\usernam\appdata\roaming\code\cache\cache_data              323.3MB     338983271           339546112
c:\users\usernam\appdata\roaming\code\cache                         323.3MB     338983271           339550208
c:\users\usernam\appdata\roaming\slack\code cache                   282MB       295745766           301752320
c:\users\usernam\appdata\roaming\code\cacheddata                    172.6MB     181008350           191647744
#>

#Requires -Version 3
[CmdletBinding()] Param(
# The root directory to search from.
[string] $Path = $env:APPDATA,
# The directory name pattern to match using -Like.
[string] $NamePattern = '*cache*'
)
Begin
{
	Use-Command.ps1 du "$env:ChocolateyInstall\bin\du.exe" -cinst sysinternals
}
Process
{
	return Get-ChildItem $Path -Directory -Recurse |
		Where-Object Name -like $NamePattern |
		Select-Object -ExpandProperty FullName |
		ForEach-Object {du -ct -nobanner $_ |Select-Object -skip 1} |
		ConvertFrom-Csv -Delimiter "`t" -Header Path,CurrentFileCount,CurrentFileSize,FileCount,DirectoryCount,DirectorySize,DirectorySizeOnDisk |
		ForEach-Object {[pscustomobject]@{
			Path                = $_.Path
			Size                = [long] $_.DirectorySize |Format-ByteUnits.ps1 -Precision 1
			DirectorySize       = [long] $_.DirectorySize
			DirectorySizeOnDisk = [long] $_.DirectorySizeOnDisk
		}} |
		Sort-Object DirectorySize -Descending
}
