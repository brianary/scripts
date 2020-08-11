<#
.Synopsis
	Create a Windows shortcut.

.Parameter Name
	The filename of the shortcut, typically including a .lnk extension.

.Parameter TargetPath
	The path of the file the shortcut will point to.

.Parameter Arguments
	Any command-line parameters to pass to the TargetPath, if it is a program.

.Parameter WorkingDirectory
	The folder to run TargetPath in.

.Parameter Description
	Some descriptive text for the shortcut.

.Parameter Hotkey
	A Windows Explorer key combination to open the shortcut, usually starting with
	"Ctrl + Alt +".

.Parameter IconLocation
	The path to a file with an icon to use, and an index, e.g.

		%SystemRoot%\system32\SHELL32.dll,244

.Parameter WindowStyle
	The state the window should start in: Normal, Maximized, or Minimized.

.Parameter RunAsAdministrator
	Indicates the shortcut should invoke UAC and run as an admin.

.Link
	https://ss64.com/vb/shortcut.html

.Example
	New-Shortcut -Path "$Home\Desktop\Explorer.lnk" -TargetPath '%SystemRoot%\explorer.exe' -RunAsAdministrator

	Creates an Explorer shortcut on the desktop that runs as admin.
#>

[CmdletBinding()][OutputType([void])] Param(
[Parameter(Position=0,Mandatory=$true)][Alias('Name')][string] $Path,
[Parameter(Position=1,Mandatory=$true)][string] $TargetPath,
[Parameter(Position=2)][string] $Arguments,
[Parameter(Position=3)][Alias('StartIn')][string] $WorkingDirectory,
[Alias('Comment')][string] $Description,
[Alias('ShortcutKey')][string] $Hotkey,
[string] $IconLocation,
[Alias('Run')][ValidateSet('Normal','Maximized','Minimized')][string] $WindowStyle,
[Alias('Admin')][switch] $RunAsAdministrator
)

$sh = New-Object -ComObject WScript.Shell
[Environment]::CurrentDirectory = $PWD # sync IO dir to PS
$folder = Split-Path ([IO.Path]::GetFullPath($Path))
# the old WshShortcut COM component doesn't support Unicode
$file = [Net.WebUtility]::UrlEncode((Split-Path $Path -Leaf))
if(![IO.Path]::HasExtension($file)) {$file += if([uri]::IsWellFormedUriString($TargetPath,'Absolute')){'.url'}else{'.lnk'}}
$fullname = Join-Path $folder $file
$lnk = $sh.CreateShortcut($fullname)
$lnk.TargetPath = $TargetPath
if($Arguments)        {$lnk.Arguments = $Arguments}
if($WorkingDirectory) {$lnk.WorkingDirectory = $WorkingDirectory}
if($Description)      {$lnk.Description = $Description}
if($Hotkey)           {$lnk.Hotkey = $Hotkey}
if($IconLocation)     {$lnk.IconLocation = $IconLocation}
if($WindowStyle)
{
	$lnk.WindowStyle =
		switch($WindowStyle)
		{
			Normal    {1}
			Maximized {3}
			Minimized {7}
		}
}
$lnk.Save()
$lnk = $null
$sh = $null
if($RunAsAdministrator)
{ # klugdy hack
	$readbytes =
		if((Get-Command Get-Content).Parameters.Encoding.ParameterType -eq [Text.Encoding]) {@{AsByteStream=$true}}
		else {@{Encoding='Byte'}}
	[byte[]]$lnkdata = Get-Content $fullname @readbytes
	$lnkdata[0x15] = 0x20
	$lnkdata |Set-Content $fullname @readbytes
}
Rename-Item $fullname ([Net.WebUtility]::UrlDecode($file))
