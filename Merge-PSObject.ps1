<#
.Synopsis
	Create a new PSObject by recursively combining the properties of PSObjects.

.Parameter ReferenceObject
	Initial PSObject to combine.

.Parameter InputObject
	PSObjects to combine. PSObject descendant properties are recursively merged.
	Primitive values are overwritten by any matching ones in the new PSObject.

.Inputs
	System.Management.Automation.PSObject to combine.

.Outputs
	System.Management.Automation.PSObject combining the inputs.

.Link
	Get-Member

.Link
	Add-Member

.Example
	Merge-PSObject.ps1 ([pscustomobject]@{a=1;b=2}) ([pscustomobject]@{b=0;c=3})

	a b c
	- - -
	1 0 3

.Example
	'{"a":1,"b":{"u":3},"c":{"v":5}}','{"a":{"w":8},"b":2,"c":{"x":6}}' |ConvertFrom-Json |Merge-PSObject.ps1 -Force |ConvertTo-Json

	{
		"a":  {
				"w":  8
			},
		"b":  2,
		"c":  {
				"v":  5,
				"x":  6
			}
	}
#>

#Requires -Version 3
[CmdletBinding()][OutputType([PSObject])] Param(
[Parameter(Position=0)][PSObject] $ReferenceObject = [pscustomobject]@{},
[Parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true,ValueFromRemainingArguments=$true)][PSObject[]] $InputObject,
[switch] $Force
)
Begin {$value = $ReferenceObject}
Process
{
	foreach($o in $InputObject)
	{
		foreach($p in $o |Get-Member -Type Properties)
		{
			$name,$type = $p.Name,$p.MemberType
			$newvalue = $o.$name
			Write-Verbose "Merging $($p.TypeName) $type {`"$name`":$($newvalue|ConvertTo-Json -c)} into $($value|ConvertTo-Json -c)"
			if(!($value |Get-Member $name -Type $type)) {$value |Add-Member $name -Type $type -Value $newvalue}
			elseif($Force)
			{
				$currentvalue = $value.$name
				$value.$name =
					if($currentvalue -isnot [PSObject] -or $newvalue -isnot [PSObject]) {$newvalue}
					else {Merge-PSObject.ps1 $currentvalue $newvalue}
			}
			elseif($value.$name -is [PSObject] -and $newvalue -is [PSObject])
			{
				$value.$name = Merge-PSObject.ps1 $value.$name $newvalue
			}
			Write-Verbose "Merged: $($value |ConvertTo-Json -c)"
		}
	}
}
End {$value}
