<#
.SYNOPSIS
Tests for a given common file type by magic number.

.INPUTS
System.String path of a file to test.

.OUTPUTS
System.Boolean affirming that the magic number for the specified file type was found.

.FUNCTIONALITY
Data formats

.LINK
https://en.wikipedia.org/wiki/List_of_file_signatures

.LINK
https://blogs.msdn.microsoft.com/sergey_babkins_blog/2015/01/02/powershell-script-blocks-are-not-closures/

.LINK
http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_206

.LINK
http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_403

.LINK
Test-MagicNumber.ps1

.EXAMPLE
Test-FileTypeMagicNumber.ps1 utf8 README.md

True if a utf-8 signature (or "BOM", byte-order-mark) is found.

.EXAMPLE
Test-FileTypeMagicNumber.ps1 png avatar.png

True if avatar.png contains the expected png magic number.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param(
<#
The file type to test for.

This is generally the MIME subtype or Unicode text encoding, with some exceptions.

Several types require the presence of an optional header or prefix for positive identification of a file type,
such as "<?xml" for xml or "%YAML " for yaml.

Text files require either a UTF BOM/SIG, or must end with a newline (U+000A) and not contain any NUL (U+0000)
characters (in the first 1KB sampled), or just not contain any characters above 7-bit US-ASCII in the first 1KB.
#>
[Parameter(Position=0,Mandatory=$true)]
[ValidateSet('7z','aiff','avi','bmp','cab','dataweave','exe','flac','flif','gif','gzip','ico','iso','javaclass',
'jpeg','midi','mkv','mp3','mpeg','msoffice','ogg','pdf','png','postscript','psd','raml','rar','rtf','tar','text',
'tiff','utf16','utf16be','utf32','utf32be','utf8','wasm','wav','webm','webp','wmv','xml','yaml','zip')]
[string] $FileType,
# The file to test.
[Parameter(Position=1,ValueFromPipelineByPropertyName=$true)]
[ValidateScript({Test-Path $_ -Type Leaf})][Alias('FullName')][string] $Path
)
Begin
{
    Write-Verbose "Testing for $FileType magic number"
	$readbytes =
		if((Get-Command Get-Content).Parameters.Encoding.ParameterType -eq [Text.Encoding]) {@{AsByteStream=$true}}
		else {@{Encoding='Byte'}}
    [scriptblock]$test =
        switch($FileType)
        {
            text
            {{ param($f)
                return (Test-MagicNumber.ps1 0xEF,0xBB,0xBF $f) -or  # UTF-8 SIG
                    (Test-MagicNumber.ps1 0xFE,0xFF $f) -or          # UTF-16 BOM (big-endian)
                    (Test-MagicNumber.ps1 0xFF,0xFE $f) -or          # UTF-16 BOM (little-endian)
                    # US-ASCII (POSIX)
                    ((Test-MagicNumber.ps1 0x0A $f -Offset -1) -and (0 -notin (Get-Content $f @readbytes -Total 1KB))) -or
                    (!(Get-Content $f @readbytes -Total 1KB |Where-Object {$_ -gt 0x7F -or $_ -eq 0}))
            }}
            xml
            {{ param($f)
                return (Test-MagicNumber.ps1 0xEF,0xBB,0xBF,0x3C,0x3F,0x78,0x6D,0x6C $f) -or
                    (Test-MagicNumber.ps1 0x3C,0x3F,0x78,0x6D,0x6C $f) -or
                    (Test-MagicNumber.ps1 0xFE,0xFF,0x00,0x3C,0x00,0x3F,0x00,0x78,0x00,0x6D,0x00,0x6C $f) -or
                    (Test-MagicNumber.ps1 0xFF,0xFE,0x3C,0x00,0x3F,0x00,0x78,0x00,0x6D,0x00,0x6C,0x00 $f)
            }}
            yaml
            {{ param($f)
                return (Test-MagicNumber.ps1 0xEF,0xBB,0xBF,0x25,0x59,0x41,0x4D,0x4C,0x20 $f) -or
                    (Test-MagicNumber.ps1 0x25,0x59,0x41,0x4D,0x4C,0x20 $f) -or
                    (Test-MagicNumber.ps1 0xFE,0xFF,0x00,0x25,0x00,0x59,0x00,0x41,0x00,0x4D,0x00,0x4C,0x00,0x20 $f) -or
                    (Test-MagicNumber.ps1 0xFF,0xFE,0x25,0x00,0x59,0x00,0x41,0x00,0x4D,0x00,0x4C,0x00,0x20,0x00 $f)
            }}
            raml
            {{ param($f)
                return (Test-MagicNumber.ps1 0xEF,0xBB,0xBF,0x23,0x25,0x52,0x41,0x4D,0x4C,0x20 $f) -or
                    (Test-MagicNumber.ps1 0x23,0x25,0x52,0x41,0x4D,0x4C,0x20 $f) -or
                    (Test-MagicNumber.ps1 0xFE,0xFF,0x00,0x23,0x00,0x25,0x00,0x52,0x00,0x41,0x00,0x4D,0x00,0x4C,0x00,0x20 $f) -or
                    (Test-MagicNumber.ps1 0xFF,0xFE,0x23,0x00,0x25,0x00,0x52,0x00,0x41,0x00,0x4D,0x00,0x4C,0x00,0x20,0x00 $f)
            }}
            dataweave
            {{ param($f)
                return (Test-MagicNumber.ps1 0xEF,0xBB,0xBF,0x25,0x64,0x77,0x20 $f) -or
                    (Test-MagicNumber.ps1 0x25,0x64,0x77,0x20 $f) -or
                    (Test-MagicNumber.ps1 0xFE,0xFF,0x00,0x25,0x00,0x64,0x00,0x77,0x00,0x20 $f) -or
                    (Test-MagicNumber.ps1 0xFF,0xFE,0x25,0x00,0x64,0x00,0x77,0x00,0x20,0x00 $f)
            }}
            gif
            {{ param($f)
                return (Test-MagicNumber.ps1 0x47,0x49,0x46,0x38,0x39,0x61 $f) -or
                    (Test-MagicNumber.ps1 0x47,0x49,0x46,0x38,0x37,0x61 $f)
            }}
            tiff
            {{ param($f)
                return (Test-MagicNumber.ps1 0x49,0x49,0x2A,0 $f) -or
                    (Test-MagicNumber.ps1 0x4D,0x4D,0,0x2A $f)
            }}
            mp3
            {{ param($f)
                return (Test-MagicNumber.ps1 0xFF,0xFB $f) -or
                    (Test-MagicNumber.ps1 0x49,0x44,0x33 $f)
            }}
            mpeg
            {{ param($f)
                return (Test-MagicNumber.ps1 0,0,0x01,0xBA $f) -or
                    (Test-MagicNumber.ps1 0,0,0x01,0xB3 $f) -or
                    (Test-MagicNumber.ps1 0x47 $f)
            }}
            rar
            {{ param($f)
                return (Test-MagicNumber.ps1 0x52,0x61,0x72,0x21,0x1A,0x07,0x01,0 $f) -or
                    (Test-MagicNumber.ps1 0x52,0x61,0x72,0x21,0x1A,0x07,0 $f)
            }}
            tar
            {{ param($f)
                return (Test-MagicNumber.ps1 0x75,0x73,0x74,0x61,0x72,0,0x30,0x30 $f -Offset 0x101) -or
                    (Test-MagicNumber.ps1 0x75,0x73,0x74,0x61,0x72,0x20,0x20,0 $f -Offset 0x101)
            }}
            jpeg
            {{ param($f)
                return (Test-MagicNumber.ps1 0xFF,0xD8 $f) -and
                    (Test-MagicNumber.ps1 0xFF,0xD9 $f -Offset (-2))
            }}
            aiff
            {{ param($f)
                return (Test-MagicNumber.ps1 0x46,0x4F,0x52,0x4D $f) -and
                    (Test-MagicNumber.ps1 0x41,0x49,0x46,0x46 $f -Offset 9)
            }}
            wav
            {{ param($f)
                return (Test-MagicNumber.ps1 0x52,0x49,0x46,0x46 $f) -and
                    (Test-MagicNumber.ps1 0x57,0x41,0x56,0x45 $f -Offset 9)
            }}
            avi
            {{ param($f)
                return (Test-MagicNumber.ps1 0x52,0x49,0x46,0x46 $f) -and
                    (Test-MagicNumber.ps1 0x41,0x56,0x49,0x20 $f -Offset 9)
            }}
            webp
            {{ param($f)
                return (Test-MagicNumber.ps1 0x52,0x49,0x46,0x46 $f) -and
                    (Test-MagicNumber.ps1 0x57,0x45,0x42,0x50 $f -Offset 9)
            }}
            iso
            {{ param($f)
                foreach($offset in 0x8001,0x8801,0x9001)
                {if(Test-MagicNumber.ps1 0x43,0x44,0x30,0x30,0x31 $f -Offset $offset){return $true}}
                return $false
            }}
            default
            {
                [int]$offset = 0
                [byte[]]$bytes =
                    switch($FileType)
                    {
                        utf8 {0xEF,0xBB,0xBF}
                        utf16 {0xFF,0xFE}
                        utf16be {0xFE,0xFF}
                        utf32 {0xFF,0xFE,0,0}
                        utf32be {0,0,0xFE,0xFF}
                        rtf {0x7B,0x5C,0x72,0x74,0x66,0x31}
                        msoffice {0xD0,0xCF,0x11,0xE0,0xA1,0xB1,0x1A,0xE1}
                        bmp {0x42,0x4D}
                        ico {0,0,0x01,0}
                        png {0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A}
                        flif {0x46,0x4C,0x49,0x46}
                        psd {0x38,0x42,0x50,0x53}
                        postscript {0x25,0x21,0x50,0x53}
                        pdf {0x25,0x50,0x44,0x46}
                        midi {0x4D,0x54,0x68,0x64}
                        ogg {0x4F,0x67,0x67,0x53}
                        flac {0x66,0x4C,0x61,0x43}
                        wmv {0x30,0x26,0xB2,0x75,0x8E,0x66,0xCF,0x11,0xA6,0xD9,0x00,0xAA,0x00,0x62,0xCE,0x6C}
                        mkv {0x46,0x4C,0x49,0x46}
                        webm {0x46,0x4C,0x49,0x46}
                        zip {0x50,0x4B} # jar/war, xpi, apk, ODF, OOXML, docx/xslx/pptx/vsdx
                        7z {0x37,0x7A,0xBC,0xAF,0x27,0x1C}
                        cab {0x4D,0x53,0x43,0x46}
                        gzip {0x1F,0x8B}
                        wasm {0,0x61,0x73,0x6d}
                        javaclass {0xCA,0xFE,0xBA,0xBE}
                        exe {0x4D,0x5A}
                        default {throw "Unknown file type: $FileType"}
                    }
                {param($f); return (Test-MagicNumber.ps1 $bytes $f -Offset $offset)}.GetNewClosure()
            }
        }
}
Process {if($Path){&$test $Path}}
