<#
.Synopsis
	Create a new dictionary by recursively combining the key-value pairs provided dictionaries.

.Parameter ReferenceObject
	Initial dictionary value to combine.

.Parameter InputObject
	Hashtables or other dictionaries to combine.

.Parameter Force
	For matching keys, overwrites old values with new ones.
	By default, only new keys are added.

.Inputs
	System.Collections.IDictionary to combine.

.Outputs
	System.Collections.IDictionary combining the inputs.

.Example
	Merge-Dictionary.ps1 @{a=1;b=2} @{b=0;c=3}

	Name                           Value
	----                           -----
	b                              2
	c                              3
	a                              1

.Example
	@{b=0;c=3},@{c=4;d=5} |Merge-Dictionary.ps1 @{a=1;b=2} -Force

	Name                           Value
	----                           -----
	b                              0
	c                              4
	a                              1
	d                              5

.Example
	@{b=0;c=3},@{c=4;d=5} |Merge-Dictionary.ps1

	Name                           Value
	----                           -----
	c                              3
	b                              0
	d                              5
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Collections.IDictionary])] Param(
[Parameter(Position=0)][Collections.IDictionary] $ReferenceObject = @{},
[Parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true,ValueFromRemainingArguments=$true)][Collections.IDictionary[]] $InputObject,
[switch] $Force
)
Begin
{
	$value = $ReferenceObject
	$resolve =
		if($Force) {{Param($key,$diff); Write-Debug "Resolve: overwrite '$key'"; $value.Remove($key)}}
		else {{Param($key,$diff); Write-Debug "Resolve: skip new '$key'"; $diff.Remove($key)}}
}
Process
{
	foreach($hash in $InputObject)
	{
		$h = $hash.Clone()
		$h.Keys |where {$value.ContainsKey($_)} |foreach {$resolve.Invoke($_,$h)}
		$value += $h
	}
}
End {$value}
