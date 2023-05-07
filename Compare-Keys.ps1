<#
.SYNOPSIS
Returns the differences between two dictionaries.

.INPUTS
System.Collections.IDictionary to compare to the reference dictionary.

.OUTPUTS
System.Management.Automation.PSObject with these properties:
* Key: The dictionary key being compared.
* Action: A Data.DataRowState that indicates whether the key-value pair has been
  Added, Deleted, Modified, or Unchanged.
* ReferenceValue: The original value.
* DifferenceValue: The new value.

.FUNCTIONALITY
Dictionary

.LINK
Compare-Object

.LINK
Group-Object

.LINK
ForEach-Object

.LINK
Sort-Object

.EXAMPLE
Compare-Keys.ps1 @{ A = 1; B = 2; C = 3 } @{ D = 6; C = 4; B = 2 } -IncludeEqual

Key    Action ReferenceValue DifferenceValue
---    ------ -------------- ---------------
A     Deleted              1
B   Unchanged              2 2
C    Modified              3 4
D       Added                6
#>

#Requires -Version 7
[CmdletBinding()] Param(
# The original dictionary to compare.
[Parameter(Position=0,Mandatory=$true)][Collections.IDictionary] $ReferenceDictionary,
# A dictionary to compare to the original.
[Parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true)][Collections.IDictionary] $DifferenceDictionary,
# Indicates that different values should be ignored.
[switch] $ExcludeDifferent,
# Indicates that identical values should be included.
[switch] $IncludeEqual
)
Process
{
	if([Environment]::Version.Major -lt 7)
	{
		$refEntries = @($ReferenceDictionary.GetEnumerator()) |
			Add-Member -MemberType ScriptMethod -Name ToString -Value {'[{0}, {1}]' -f $this.Key, $this.Value} -Force -PassThru
		$diffEntries = @($DifferenceDictionary.GetEnumerator()) |
			Add-Member -MemberType ScriptMethod -Name ToString -Value {'[{0}, {1}]' -f $this.Key, $this.Value} -Force -PassThru
	}
	else
	{
		$refEntries = @($ReferenceDictionary.GetEnumerator())
		$diffEntries = @($DifferenceDictionary.GetEnumerator())
	}
	Compare-Object $refEntries $diffEntries -ExcludeDifferent:$ExcludeDifferent -IncludeEqual:$IncludeEqual |
		Group-Object {$_.InputObject.Key} |
		ForEach-Object {
			$key = $_.Values[0]
			if($_.Group.Count -gt 1)
			{
				$refValue, $diffValue = ($_.Group |Sort-Object SideIndicator).InputObject.Value
				[pscustomobject]@{
					Key = $key
					Action = [Data.DataRowState]::Modified
					ReferenceValue = $refValue
					DifferenceValue = $diffValue
				}
			}
			else
			{
				$value = $_.Group[0].InputObject.Value
				switch($_.Group[0].SideIndicator)
				{
					'<='
					{
						[pscustomobject]@{
							Key = $key
							Action = [Data.DataRowState]::Deleted
							ReferenceValue = $value
							DifferenceValue = $null
						}
					}
					'=='
					{
						[pscustomobject]@{
							Key = $key
							Action = [Data.DataRowState]::Unchanged
							ReferenceValue = $value
							DifferenceValue = $value
						}
					}
					'=>'
					{
						[pscustomobject]@{
							Key = $key
							Action = [Data.DataRowState]::Added
							ReferenceValue = $null
							DifferenceValue = $value
						}
					}
				}
			}
		}
}
