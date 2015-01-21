<#
.Synopsis
Searches files for pattern, displays matches, opens in text editor.
.Parameter Pattern
Specifies the text to find. Type a string or regular expression. 
If you type a string, use the SimpleMatch parameter.
.Parameter Filters
Specifies wildcard filters that files must match one of.
.Parameter Path
Specifies a path to one or more locations. Wildcards are permitted. 
The default location is the current directory (.).
.Parameter Include
Wildcard patterns files must match one of (slower than Filter).
.Parameter Exclude
Wildcard patterns files must not match any of.
.Parameter CaseSensitive
Makes matches case-sensitive. By default, matches are not case-sensitive. 
.Parameter List
Returns only the first match in each input file. 
By default, Select-String returns a MatchInfo object for each match it finds.
.Parameter NotMatch
Finds text that does not match the specified pattern.
.Parameter SimpleMatch
Uses a simple match rather than a regular expression match. 
In a simple match, Select-String searches the input for the text in the Pattern parameter. 
It does not interpret the value of the Pattern parameter as a regular expression statement.
.Parameter NoRecurse
Disables searching subdirectories.
.Example
C:\PS> Find-Lines 'using System;' *.cs "$env:USERPROFILE\Documents\Visual Studio*\Projects" -CaseSensitive -List

This command searches all of the .cs files in the Projects directory (or directories) and subdirectories,
displays the first matching line of each file with a match, then opens the file to the correct line in the editor.
#>
[CmdletBinding()]Param(
  [Parameter(Position=0,Mandatory=$true)][string[]]$Pattern,
  [Parameter(Position=1)][string[]]$Filters,
  [Parameter(Position=2)][string[]]$Path,
  [string[]]$Include,
  [string[]]$Exclude,
  [switch]$CaseSensitive,
  [switch]$List,
  [switch]$NotMatch,
  [switch]$SimpleMatch,
  [switch]$NoRecurse
)
# set up splatting
$lsopt = @{Recurse=!$NoRecurse}
if($Path) { $lsopt.Path=$Path }
if($Include) { $lsopt.Include=$Include }
if($Exclude) { $lsopt.Exclude=$Exclude }
$ssopt = @{'Pattern'=$Pattern}
if($CaseSensitive) { $ssopt.CaseSensitive=$true }
if($List) { $ssopt.List=$true }
if($NotMatch) { $ssopt.NotMatch=$true }
if($SimpleMatch) { $ssopt.SimpleMatch=$true }
# the filter parameter is much faster than the include parameter
Select-String -Path ($( if($Filters) { $Filters|% {ls @lsopt -Filter $_} } else { ls @lsopt } ) |
    ? {Test-Path $_.FullName -PathType Leaf}) @ssopt |
  ogv -p -t "Search: '$Pattern' $Filters" |
  % {emeditor $_.Path /l $_.LineNumber} #TODO: customize editor