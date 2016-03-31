<#
.Synopsis
    Converts bytes to largest possible units, to improve readability.
    
.Parameter Bytes
    The number of bytes to express in larger units.
    
.Parameter Precision
    The maximum number of digits after the decimal to keep.
    The default is 16 (the maximum).
    
.Parameter UseSI
    Displays unambiguous SI units (with a space).
    By default, native PowerShell units are used
    (without a space, to allow round-tripping the value,
    though there may be significant rounding loss depending on precision).
    
.Example
    Format-ByteUnits 65536
    64KB
    
.Example
    Format-ByteUnits 9685059 -dot 1 -si
    9.2 MiB
    
.Example
    ls *.log |measure -sum Length |select -exp Sum |Format-ByteUnits -dot 2 -si
    302.39 MiB
    
.Inputs
    A integer (up to 64-bit) representing a number of bytes.
    
.Link
    http://en.wikipedia.org/wiki/Binary_prefix
    
.Link
    http://physics.nist.gov/cuu/Units/binary.html
#>

#requires -version 2
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][int64]$Bytes,
[Alias('Digits','dot')][ValidateRange(0,16)][byte]$Precision = 16,
[Alias('si')][switch]$UseSI
)
Process
{
$pfmt = New-Object String '#',$Precision
if($bytes -gt 1PB)     {"{0:0.$pfmt}{1}" -f ($bytes / 1PB),@("PB"," PiB")[$UseSI.IsPresent]}
elseif($bytes -gt 1TB) {"{0:0.$pfmt}{1}" -f ($bytes / 1TB),@("TB"," TiB")[$UseSI.IsPresent]}
elseif($bytes -gt 1GB) {"{0:0.$pfmt}{1}" -f ($bytes / 1GB),@("GB"," GiB")[$UseSI.IsPresent]}
elseif($bytes -gt 1MB) {"{0:0.$pfmt}{1}" -f ($bytes / 1MB),@("MB"," MiB")[$UseSI.IsPresent]}
elseif($bytes -gt 1KB) {"{0:0.$pfmt}{1}" -f ($bytes / 1KB),@("KB"," KiB")[$UseSI.IsPresent]}
else                   {"{0} bytes" -f  $bytes}
}