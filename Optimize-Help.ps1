<#
.SYNOPSIS
Cleans up comment-based help blocks by fully unindenting and capitalizing dot keywords.

.INPUTS
An object with a Path or FullName property.

.EXAMPLE
Optimize-Help.ps1 Get-Thing.ps1

Unindents help and capitalizes dot keywords in Get-Thing.ps1
#>

#Requires -Version 7
[CmdletBinding()] Param(
# The script to process.
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string] $Path
)
Begin
{
	$EOL = [Environment]::NewLine
	function Get-ParameterDocs([Parameter(ValueFromPipeline=$true)][string]$script)
	{
		$params = [ordered]@{}
		foreach($param in [regex]::Matches($script, '(?ms)^\.PARAMETER +(?<ParameterName>\w+)\r?\n(?<Description>.*?)(?=\s*^\.\w+|\s*^#>)'))
		{
			$params.Add($param.Groups['ParameterName'].Value, $param.Groups['Description'].Value)
		}
		return $params
	}
}
Process
{
	$script = [regex]::Replace((Get-Content $Path -Raw).TrimEnd(), '(?s)<#\s*(\.\w+.*?)#>',
		{[regex]::Replace(($args[0] -replace '(?m)^[\x09\x20]+',''), '(?m)^(\.\w+)\b', {"$($args[0])".ToUpper()} )})
	$params = $script |Get-ParameterDocs
	$script = $script -replace '(?ms)^\.PARAMETER +\w+\r?\n.*?\s*(?=^\.\w+|^#>)'
	$script = [regex]::Replace($script, '(?ms)(?<=^\[CmdletBinding.*?\]\s*Param\(\r?\n)(?<ParameterDefs>.*?\r?\n)(?=^\))',
		{
			[string[]] $docparams = @()
			foreach($p in $args[0] -split '(?<=\] *\$\w+\b(?: *= *.*?)?),\r?\n')
			{
				if($p -match '\] *\$(?<ParameterName>\w+)\b')
				{
					$name = $Matches.ParameterName
					if($params.Contains($name))
					{
						$doc = $params[$name]
						$params.Remove($name)
						$docparams += $doc -match '\n' ? "<#$EOL$doc$EOL#>$EOL$p" : "# $doc$EOL$p";
					}
					else
					{
						Write-Warning "Parameter $name documentation not found in $Path"
						$docparams += $p
					}
				}
				else
				{
					Write-Warning "Could not find parameter name in:$EOL$p"
					$docparams += $p
				}
			}
			foreach($k in $params.Keys) {Write-Warning "Could not find parameter definition for $k in $Path$EOL$($params[$k])"}
			$docparams -join ",$EOL"
		})
	$script |Out-File $Path utf8BOM
}
