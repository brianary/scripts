<#
.SYNOPSIS
Returns characters based on Unicode code point name, GitHub short code, or HTML entity.

.INPUTS
System.String of a character name.

.OUTPUTS
System.String of the character(s) referenced by name.

.FUNCTIONALITY
Unicode

.LINK
https://www.unicode.org/Public/UCD/latest/ucd/NameAliases.txt

.LINK
https://html.spec.whatwg.org/multipage/named-characters.html

.EXAMPLE
Get-UnicodeByName.ps1 hyphen-minus

-

.EXAMPLE
Get-UnicodeByName.ps1 slash

/

.EXAMPLE
Get-UnicodeByName.ps1 :zero:

[0]

.EXAMPLE
Get-UnicodeByName.ps1 '&amp;'

&

.EXAMPLE
Get-UnicodeByName.ps1 BEL

(beeps)
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
# The name or alias of a Unicode character.
[Parameter(ParameterSetName='Name',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $Name,
# Update the character name database.
[Parameter(ParameterSetName='Update')][switch] $Update
)
Begin
{
	$cc = ConvertFrom-StringData (Get-Content ([io.path]::ChangeExtension($PSCommandPath,'cc.txt')) -Raw)
	$codepoint = ConvertFrom-StringData (Get-Content ([io.path]::ChangeExtension($PSCommandPath,'txt')) -Raw)
	$html = Get-Content ([io.path]::ChangeExtension($PSCommandPath,'html.json')) -Raw |ConvertFrom-Json -AsHashtable
	$github = ConvertFrom-StringData (Get-Content ([io.path]::ChangeExtension($PSCommandPath,'github.txt')) -Raw)
	filter ConvertTo-Chars([Parameter(ValueFromPipeline)][string] $Value)
	{
		return (($Value -split '\W+') |
			ForEach-Object {[char]::ConvertFromUtf32([convert]::ToInt32($_,16))}) -join ''
	}
}
Process
{
	if($Update)
	{
		$conflictingOldNames = '0007','01B7','0292','0404','0406','0454','0456','10D0','10D1','10D2','10D3','10D4',
			'10D5','10D6','10D7','10D8','10D9','10DA','10DB','10DC','10DD','10DE','10DF','10E0','10E1','10E2','10E3',
			'10E4','10E5','10E6','10E7','10E8','10E9','10EA','10EB','10EC','10ED','10EE','10EF','10F0','10F1','10F2',
			'10F3','10F4','10F5','2016','314A','314B','314D','3209','320A','320C','3269','326A','326C','33B7','FFBA',
			'FFBB','FFBD'
		Get-UnicodeData.ps1 |
			ForEach-Object {
				if($_.OldName -and $_.Value -notin $conflictingOldNames){$_.OldName+'='+$_.Value}
				if($_.Name -ne '<control>'){$_.Name+'='+$_.Value}
			} |Out-File ([io.path]::ChangeExtension($PSCommandPath,'txt')) -Encoding utf8
		Invoke-WebRequest https://html.spec.whatwg.org/entities.json -OutFile ([io.path]::ChangeExtension($PSCommandPath,'html.json'))
		(Invoke-RestMethod https://api.github.com/emojis).PSObject.Properties |
			Where-Object {$_.Value -notlike "*/$($_.Name).png[?]v8"} |
			ForEach-Object {':'+$_.Name+':='+(((([uri]$_.Value).Segments[-1]) -replace '\.png\z').ToUpper() -replace '-',',')} |
			Out-File ([io.path]::ChangeExtension($PSCommandPath,'github.txt')) -Encoding utf8
		Write-Information 'Updated.'
		return
	}
	else
	{
		if($cc.ContainsKey($Name)) {return $cc[$Name] |ConvertTo-Chars}
		elseif($github.ContainsKey($Name)) {return $github[$Name] |ConvertTo-Chars}
		elseif($html.ContainsKey($Name)) {return $html[$Name].characters -join ''}
		else {return $codepoint[$Name] |ConvertTo-Chars}
	}
}
