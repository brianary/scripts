<#
.Synopsis
Returns categorical information about a range of characters.
#>

#requires -version 2
[CmdletBinding()] Param(
[int]$StartValue = [char]::MinValue,
[int]$StopValue  = [char]::MaxValue,
[switch]$IsASCII
)
if($IsASCII -and $StopValue -gt 127) { $StopValue = 127 }
$invalidUserNameChars = '"/\[]:;|=,+*?<>'.ToCharArray() # https://technet.microsoft.com/en-us/library/bb726984.aspx
for($_ = $StartValue; $_ -le $StopValue; $_++)
{
    $properties = [ordered]@{
        Character       = [char]$_
        Value           = $_
        CodePoint       = 'U+{0:X4}' -f $_
        UnicodeCategory = [char]::GetUnicodeCategory($_)
        IsASCII         = $_ -le 127
        IsControl       = [char]::IsControl($_)
        IsDigit         = [char]::IsDigit($_)
        IsHighSurrogate = [char]::IsHighSurrogate($_)
        IsLegalUserName = $invalidUserNameChars -notcontains [char]$_
        IsLegalFileName = [IO.Path]::InvalidPathChars -notcontains [char]$_
        IsLetter        = [char]::IsLetter($_)
        IsLetterOrDigit = [char]::IsLetterOrDigit($_)
        IsLower         = [char]::IsLower($_)
        IsLowSurrogate  = [char]::IsLowSurrogate($_)
        IsNumber        = [char]::IsNumber($_)
        IsPunctuation   = [char]::IsPunctuation($_)
        IsSeparator     = [char]::IsSeparator($_)
        IsSurrogate     = [char]::IsSurrogate($_)
        IsSymbol        = [char]::IsSymbol($_)
        IsUpper         = [char]::IsUpper($_)
        IsWhiteSpace    = [char]::IsWhiteSpace($_)
    }
    New-Object PSObject -Property $properties
}