<#
.SYNOPSIS
Returns the current (cached) Unicode character data.

.OUTPUTS
System.Management.Automation.PSCustomObject for each character entry with these properties:

.LINK
https://www.unicode.org/L2/L1999/UnicodeData.html
#>

#Requires -Version 7
[CmdletBinding()] Param(
# The location of the latest Unicode data.
[uri] $Url = 'https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt',
[string] $DataFile = (Join-Path $env:TEMP ($Url.Segments[-1]))
)

function Save-Data
{
    if(!(Test-Path $DataFile -Type Leaf))
    {
        $http = Invoke-WebRequest $Url -OutFile $DataFile -PassThru
        Write-Information "Downloaded $Url to $(Join-Path $PWD $DataFile)"
        [datetime] $lastmod = "$($http.Headers['Last-Modified'])"
        (Get-Item $DataFile).LastWriteTime = $lastmod
    }
    else
    {
        $http = Invoke-WebRequest $Url -Method Head
        [datetime] $lastmod = "$($http.Headers['Last-Modified'])"
        if((Get-Item $DataFile).LastWriteTime -lt $lastmod)
        {
            Invoke-WebRequest $Url -OutFile $DataFile
            Write-Information "Updated $Url to $(Join-Path $PWD $DataFile)"
            (Get-Item $DataFile).LastWriteTime = $lastmod
        }
    }
}

function Read-Data
{
	Import-Csv $DataFile -Delimiter ';' -Header Value,Name,Catgory,CombiningClass,BidirectionalCategory,
		DecompositionMapping,DecimalDigitValue,DigitValue,NumericValue,Mirrored,OldName,Comment,
		Upper,Lower,Title
}

Save-Data
Read-Data
