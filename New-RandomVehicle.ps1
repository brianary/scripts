<#
.Synopsis
	Generates random vehicle details with a valid VIN.

.Link
	https://vingenerator.org
#>

#Requires -Version 3
[CmdletBinding()] Param()

[regex] $detailpattern = '^VIN Description: (?<Year>\d{4}) (?<MakeModel>.*)$'
$vinpage = Invoke-WebRequest https://vingenerator.org -UseBasicParsing:$false
[string] $vin = $vinpage.InputFields.value
[string] $details = $vinpage.ParsedHtml.getElementsByTagName('div') |
	where className -eq description |
	foreach InnerText
if($details -match $detailpattern)
{
	Import-Variables.ps1 $Matches
	[pscustomobject]@{
		Vin       = $vin
		Year      = $Year
		MakeModel = $MakeModel
	}
}
else
{
	[pscustomobject]@{
		Vin = $vin
		Description = $details
	}
}
