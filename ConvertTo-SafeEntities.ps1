<#
.Synopsis
	Encode text as XML/HTML, escaping all characters outside 7-bit ASCII.

.Parameter InputObject
	An HTML or XML string that may include emoji or other Unicode characters outside
	the 7-bit ASCII range.

.Inputs
	System.String of HTML or XML data to encode.

.Outputs
	System.String of HTML or XML data, encoded.

.Link
	https://docs.microsoft.com/dotnet/api/system.char.issurrogatepair

.Link
	https://docs.microsoft.com/dotnet/api/system.char.converttoutf32

.Example
	"$([char]0xD83D)$([char]0xDCA1) File $([char]0x2192) Save" |ConvertTo-SafeEntities.ps1

	&#x1F4A1; File &#x2192; Save

	This shows a UTF-16 surrogate pair, used internally by .NET strings, which is combined
	into a single entity reference.

.Example
	"ETA: $([char]0xBD) hour" |ConvertTo-SafeEntities.ps1

	ETA: &#xBD; hour
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputObject
)
Process
{
	[char[]] $chars =
		for ($i = 0; $i -lt $InputObject.Length; $i++)
		{
			[int] $c = [char]$InputObject[$i]
			Write-Verbose "$i : $c"
			if([char]::IsSurrogatePair($InputObject,$i))
			{ ('&#x{0:X};' -f [char]::ConvertToUtf32($InputObject,$i++)).GetEnumerator() }
			elseif(0x7F -lt $c)
			{ ('&#x{0:X};' -f $c).GetEnumerator() }
			else
			{ [char]$c }
		}
	New-Object String $chars,0,$chars.Length
}
