<#
.SYNOPSIS
Sorts, prunes, and normalizes both user and system Path entries.

#>

#Requires -Version 3
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)][OutputType([void])] Param(
<#
Look for commands with the same name within multiple Path entries, and move the entry
with the newest version ahead of the others.
#>
[switch]$ResolveConflicts
)

function Initialize-PathCollection
{
    # initialize collections
    $Script:app,$Script:user = @{},@()
    # get command extensions
    $Script:pathext = $env:PATHEXT -split ';'
    # get list of directory environment variables
    $Script:evmatch = Get-ChildItem env: |
        Where-Object {Test-Path $_.Value -PathType Container} |
        Where-Object {'windir','TMP','ProgramW6432','CommonProgramW6432','SystemDrive','HomeDrive','HomePath' -inotcontains $_.Name} |
        ForEach-Object {$_.Value = '^' + ($_.Value.Trim('\') -replace '(\W)','\$1') + '(?=\\|$)'; $_} |
        Sort-Object @{e={$_.Value.Length};asc=$false},@{e={$_.Name.Length};asc=$true}
}

function Backup-Path([Parameter(Position=0,Mandatory=$true)][EnvironmentVariableTarget]$Target)
{
    mkdir $env:LOCALAPPDATA\OptimizePath |Out-Null
    "$(Get-Date -Format u)`t$($Target)`t$([Environment]::GetEnvironmentVariable('Path',$Target))" |
        Add-Content -Path $env:LOCALAPPDATA\OptimizePath\Backup.tsv
}

filter Get-PathDetail([Parameter(Position=0,Mandatory=$true)][EnvironmentVariableTarget]$Target,
                        [Parameter(Position=1,ValueFromPipeline=$true)][string]$Entry)
{
    if([string]::IsNullOrWhiteSpace($Entry)) {return}
    $fullpath = [Environment]::ExpandEnvironmentVariables($Entry)
    Write-Verbose "$Target Path: $Entry$(if($Entry -ne $fullpath){' ('+$fullpath+')'})"
    if(!(Test-Path $fullpath -PathType Container)) {Write-Warning "$Target Path: Entry $Entry not found!"; return}
    if($Target -ne 'User' -and $entry.StartsWith("$env:USERPROFILE\")) {Write-Warning "$Target Path: Entry $entry under user profile!"; $user+= $entry; continue}
    [IO.FileInfo[]]$cmd = Get-ChildItem $fullpath -File |Where-Object {$pathext -icontains $_.Extension}
    if(!$cmd) {Write-Warning "$Target Path: Entry $Entry contains no executables."; return}
    elseif($cmd.Count -eq 1) {Write-Warning "$Target Path: Entry $Entry contains only one command! ($($cmd[0].Name))"}
    else {Write-Verbose "$Target Path: Entry $Entry contains $($cmd.Count) commands."}
    foreach($c in $cmd)
    {
        if($app[$c.Name]) {$app[$c.Name]+=$Entry}
        else {[string[]]$app[$c.Name] = $Entry}
    }
    $ev = $evmatch |Where-Object {$Entry -match $_.Value} |Select-Object -First 1
    if($ev) {Write-Verbose "$Target Path: $entry matches $($ev.Name) /$($ev.Value)/"}
    $evpath =
        if($Entry -like '%*') {$Entry}
        elseif(!$ev) {$fullpath}
        else {$Entry -ireplace $ev.Value,"%$($ev.Name)%"}
    return [pscustomobject]@{
        Name       = $Entry
        Path       = $fullpath
        EnvVarPath = $evpath
        Commands   = $cmd
        Precede    = [string[]]@()
    }
}

function Get-PathDetail([Parameter(Position=0,Mandatory=$true)][EnvironmentVariableTarget]$Target)
{
    $path = [Environment]::GetEnvironmentVariable('Path',$Target) -split ';'
    switch($Target)
    {
        Machine {$path |Get-PathDetail $Target}
        User    {($Script:user + $path) |Get-PathDetail $Target}
    }
}

function Resolve-PathConflict([Parameter(Position=0,Mandatory=$true)][EnvironmentVariableTarget]$Target,
                               [Parameter(Position=1,Mandatory=$true)][Collections.Generic.List[psobject]]$PathDetails)
{
    # examine conflicts
    if(!(Get-Command -Verb Test -Noun NewerFile)) {Set-Alias Test-NewerFile "$PSScriptRoot\Test-NewerFile.ps1"}
    foreach($c in $app.Keys |Where-Object {$app.$_.Count -gt 1})
    {
        $newest,$rest = $app[$c]
        [string[]]$precede = @()
        foreach($r in $rest)
        {
            if(Test-NewerFile (Join-Path $newest $c) (Join-Path $r $c)) {$precede += $newest; $newest = $r}
        }
        if($precede)
        {
            Write-Verbose "Executable conflict ${c}: $newest needs to be moved ahead of $($precede -join ', ')."
            $npos,$rpos = 0,0
            foreach($i in 0..($precede.Length))
            {
                if($PathDetails[$i].Name -eq $newest) {$npos = $i}
                elseif($rpos -ne 0 -and $precede -contains $PathDetails[$i].Name) {$rpos = $i}
            }
            if($npos -gt $rpos)
            {
                $n = $PathDetails[$npos]
                $PathDetails.RemoveAt($npos)
                $PathDetails.Insert($rpos,$n)
            }
        }
    }
    return $PathDetails
}

function Update-Path([Parameter(Position=0,Mandatory=$true)][EnvironmentVariableTarget]$Target)
{
    [Collections.Generic.List[psobject]]$path = Get-PathDetails $Target
    if($ResolveConflicts) {$path = Resolve-PathConflicts $path}
    if($PSCmdlet.ShouldProcess("$Target Path",'Update'))
    {
        $newpath = ($path |Select-Object -Unique -ExpandProperty EnvVarPath) -join ';'
        Write-Verbose "New $Target Path: $newpath"
        Backup-Path $Target
        [Environment]::SetEnvironmentVariable('Path',$newpath,$Target)
    }
}

Initialize-PathCollections
Update-Path Machine
Update-Path User
