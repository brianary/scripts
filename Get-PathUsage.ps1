<#
.SYNOPSIS
Returns the list of directories in the path, and the commands found in each.
#>

#Requires -Version 7
[CmdletBinding()] Param()
$AllCommandPaths = Get-Command -Type Application,ExternalScript
($env:Path -split ';') -replace '[/\\]\z' |
    Where-Object {$AllCommandPaths -like "$_\*" |Measure-Object |Where-Object Count -lt 3} -pv pathitem |
    ForEach-Object {[pscustomobject]@{ PathDirectory = $pathitem
        Commands = @($AllCommandPaths |Where-Object Path -like "$pathitem\*")
        PathExtMatch = @($env:PATHEXT -split ';' |
            ForEach-Object {Get-ChildItem $pathitem -Filter "*$_"} |
            Select-Object -ExpandProperty Name) }}
