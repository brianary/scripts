<#
.SYNOPSIS
Converts bytes to largest possible units, to improve readability.

.INPUTS
System.Numerics.BigInteger representing a number of bytes.

.OUTPUTS
System.String containing the number of bytes scaled to fit the appropriate units.

.LINK
http://en.wikipedia.org/wiki/Binary_prefix

.LINK
http://physics.nist.gov/cuu/Units/binary.html

.EXAMPLE
Format-ByteUnits 65536
64KB

.EXAMPLE
Format-ByteUnits 9685059 -dot 1 -si
9.2 MiB

.EXAMPLE
ls *.log |measure -sum Length |select -exp Sum |Format-ByteUnits -dot 2 -si
302.39 MiB
#>

#Requires -Version 2
[CmdletBinding()][OutputType([string])] Param(
# The number of bytes to express in larger units.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][bigint]$Bytes,
<#
The maximum number of digits after the decimal to keep.
The default is 16 (the maximum).
#>
[Alias('Digits','dot')][ValidateRange(0,16)][byte]$Precision = 16,
<#
Displays unambiguous SI units (with a space).
By default, native PowerShell units are used
(without a space, to allow round-tripping the value,
though there may be significant rounding loss depending on precision).
#>
[Alias('si')][switch]$UseSI
)
Process
{
    $units =
        if($UseSI)       {[ordered]@{1073741824PB=' YiB'; 1048576PB=' ZiB'; 1024PB=' EiB';
                                    1PB=' PiB';1TB=' TiB';1GB=' GiB';1MB=' MiB';1KB=' KiB';1=' B'}}
        else             {[ordered]@{1PB= 'PB'; 1TB= 'TB'; 1GB= 'GB'; 1MB= 'MB'; 1KB= 'KB'}}
    $pfmt = New-Object String '#',$Precision
    foreach($magnitude in $units.Keys)
    {
        if($Bytes -ge $magnitude) {return "{0:0.$pfmt}{1}" -f ([double]$Bytes / $magnitude),$units.$magnitude}
    }
    return $Bytes
}
