<#
.SYNOPSIS
Updates markdown content to replace level 1 & 2 ATX headers to Setext headers.

.FUNCTIONALITY
Markdown

.INPUTS
System.String containing markdown code to update.

.OUTPUTS
System.String containing updated markdown code.

.LINK
https://webcoder.info/markdown-headers.html

.EXAMPLE
Repair-MarkdownHeaders.ps1 -Path readme.md -Style SetextWithAtx

Updates the file with the specified header style.

.EXAMPLE
$content = $markdown |Repair-MarkdownHeaders.ps1 -Style Atx

Returns markdown code that uses ATX headers.
#>

#Requires -Version 7
[CmdletBinding()][OutputType([string],ParameterSetName='InputObject')] Param(
# Markdown file to update.
[Parameter(ParameterSetName='Path',Position=0,Mandatory=$true)][string] $Path,
# The text encoding to use when converting text to binary data.
[Parameter(ParameterSetName='Path',Position=1)]
[ValidateSet('ascii','utf16','utf16BE','utf32','utf32BE','utf7','utf8')]
[string] $Encoding = 'utf8',
# Markdown content to update.
[Parameter(ParameterSetName='InputObject',ValueFromPipeline=$true)][string] $InputObject,
# The style of headers to use.
[ValidateSet('Atx', 'AtxClosed', 'SetextWithAtx')]
[string] $Style = 'SetextWithAtx',
# The line endings to use.
[ValidatePattern('\A\r?\n\z')][string] $NewLine = [Environment]::NewLine
)
Begin
{
    filter Repair-Atx
    {
        [CmdletBinding()] Param(
        [Parameter(ValueFromPipeline=$true)][string] $InputObject
        )
        $md = ConvertFrom-Markdown -InputObject $InputObject
        $value = switch($md.Tokens)
        {
            {$_.Span.Length -eq 0} {}
            {$_ -is [Markdig.Syntax.HeadingBlock] -and $_.IsSetext}
            {
                $headertext = $InputObject.Substring($_.Span.Start, $_.Span.Length).TrimEnd(($_.Level -eq 1 ? '=' : '-')).Trim()
                "$(New-Object string '#',$_.Level) $headertext"
            }
            default {$InputObject.Substring($_.Span.Start, $_.Span.Length).Trim()}
        }
        return $value -join "$NewLine$NewLine"
    }

    filter Repair-AtxClosed
    {
        [CmdletBinding()] Param(
        [Parameter(ValueFromPipeline=$true)][string] $InputObject
        )
        $md = ConvertFrom-Markdown -InputObject $InputObject
        $value = switch($md.Tokens)
        {
            {$_.Span.Length -eq 0} {}
            {$_ -is [Markdig.Syntax.HeadingBlock] -and $_.IsSetext}
            {
                $headertext = $InputObject.Substring($_.Span.Start, $_.Span.Length).TrimEnd(($_.Level -eq 1 ? '=' : '-')).Trim()
                $atx = (New-Object string '#',$_.Level)
                "$atx $headertext $atx"
            }
            {$_ -is [Markdig.Syntax.HeadingBlock] -and !$_.IsSetext}
            {
                $headertext = $InputObject.Substring($_.Span.Start, $_.Span.Length).TrimStart($_.HeaderChar).Trim()
                $atx = (New-Object string '#',$_.Level)
                "$atx $headertext $atx"
            }
            default {$InputObject.Substring($_.Span.Start, $_.Span.Length).Trim()}
        }
        return $value -join "$NewLine$NewLine"
    }

    filter Repair-SetextWithAtx
    {
        [CmdletBinding()] Param(
        [Parameter(ValueFromPipeline=$true)][string] $InputObject
        )
        $md = ConvertFrom-Markdown -InputObject $InputObject
        $value = switch($md.Tokens)
        {
            {$_.Span.Length -eq 0} {}
            {$_ -is [Markdig.Syntax.HeadingBlock] -and $_.Level -lt 3 -and !$_.IsSetext}
            {
                $headertext = $InputObject.Substring($_.Span.Start, $_.Span.Length).TrimStart($_.HeaderChar).Trim()
                "$headertext$NewLine$(New-Object string ($_.Level -eq 1 ? '=' : '-'),$headertext.Length)"
            }
            default {$InputObject.Substring($_.Span.Start, $_.Span.Length).Trim()}
        }
        return $value -join "$NewLine$NewLine"
    }
}
Process
{
    switch($PSCmdlet.ParameterSetName)
    {
        InputObject {return $InputObject |& "Repair-$Style"}
        Path
        {
            $content = Get-Content $Path -Raw
            $content |& "Repair-$Style" |Out-File $Path $Encoding
        }
    }
}
