<#
.SYNOPSIS
Displays drive usage graphically, and with a human-readable summary.

.FUNCTIONALITY
Files

.INPUTS
An object with a Name property that corresponds to a drive name.

.LINK
Import-CharConstants.ps1

.LINK
Format-ByteUnits.ps1

.LINK
Write-Info.ps1

.EXAMPLE
Show-PSDriveUsage.ps1 C -AsAscii

#################_______________________________________________________________________
C:\ Windows [NTFS] 953GB = 762GB (79%) free + 191GB (20%) used

.EXAMPLE
Show-PSDriveUsage.ps1 /home -AsAscii
###################_____________________________________________________________________
/home [ext3] 4TB = 3TB (73%) free + 792GB (21%) used
#>

#Requires -Version 7
[CmdletBinding()] Param(
# A drive name to display the usage for. All ready fixed drives are displayed if none is specified.
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,ValueFromRemainingArguments=$true)][string[]] $Name = @(),
# Display the graph as ASCII.
[switch] $AsAscii
)
Begin
{
    if($AsAscii) {$usedchar, $freechar = '#', '_'}
    else {Import-CharConstants.ps1 'full block' 'light shade'; $usedchar, $freechar = ${full block}, ${light shade}}
    filter Show-DriveUsage
    {
        [CmdletBinding()] Param(
        [Parameter(ValueFromPipelineByPropertyName=$true)][string] $Name,
        [Parameter(ValueFromPipelineByPropertyName=$true)][string] $VolumeLabel,
        [Parameter(ValueFromPipelineByPropertyName=$true)][string] $DriveFormat,
        [Parameter(ValueFromPipelineByPropertyName=$true)][IO.DirectoryInfo] $RootDirectory,
        [Parameter(ValueFromPipelineByPropertyName=$true)][long] $TotalSize,
        [Parameter(ValueFromPipelineByPropertyName=$true)][long] $TotalFreeSpace,
        [Parameter(ValueFromPipelineByPropertyName=$true)][long] $AvailableFreeSpace
        )
        $blocksize, $usedspace = [long]::DivRem($TotalSize, [Console]::WindowWidth).Item1, ($TotalSize - $TotalFreeSpace)
        $usedpercent, $freepercent, $size, $free, $used, $usedgraph, $freegraph =
            ([long]::DivRem(100*$usedspace, $TotalSize).Item1),
            ([long]::DivRem(100*$AvailableFreeSpace, $TotalSize).Item1),
            ($TotalSize |Format-ByteUnits.ps1 -Precision 0),
            ($AvailableFreeSpace |Format-ByteUnits.ps1 -Precision 0),
            ($usedspace |Format-ByteUnits.ps1 -Precision 0),
            (New-Object string ($usedchar, [long]::DivRem($usedspace, $blocksize).Item1)),
            (New-Object string ($freechar, [long]::DivRem($AvailableFreeSpace, $blocksize).Item1))
        $color = switch($freepercent)
        {
            {$_ -lt 10} {'Red'}
            {$_ -lt 20} {'Yellow'}
            default {'Green'}
        }
        Write-Info.ps1 $usedgraph -fg Cyan -NoNewLine
        Write-Info.ps1 $freegraph -fg DarkCyan
        $fqdn = $Name -ne $VolumeLabel ? "$Name $VolumeLabel [$DriveFormat]" : "$Name [$DriveFormat]"
        Write-Info.ps1 "$fqdn $size = $free ($freepercent%) free + $used ($usedpercent%) used" -fg $color
    }
}
Process
{
    if($Name) {$Name |ForEach-Object {[IO.DriveInfo] $_} |Show-DriveUsage}
    else
    {
        [IO.DriveInfo]::GetDrives() |
            Where-Object {$_.DriveType -eq 'Fixed' -and $_.IsReady -and $_.TotalSize -gt 0} |
            Show-DriveUsage
    }
}
