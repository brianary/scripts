<#
.SYNOPSIS
Copies configured issue labels from one repo to another.

.FUNCTIONALITY
Git and GitHub

.INPUTS
An object with these properties:
* owner or DestinationOwnerName (optional)
* name or DestinationRepositoryName

.LINK
Get-GitHubLabel

.LINK
New-GitHubLabel

.LINK
Set-GitHubLabel

.LINK
Remove-GitHubLabel

.EXAMPLE
Copy-GitHubLabels.ps1 -OwnerName brianary -RepositoryName scripts -DestinationRepositoryName webcoder

Inserts new labels from the brianary/scripts repo to the brianary/webcoder repo, and also
updates attributes like description and color from matching labels in the source.
#>

#Requires -Version 7
#Requires -Modules PowerShellForGitHub
[CmdletBinding()] Param(
# The source repository's owner name.
[Parameter(Position=0,Mandatory=$true)][string] $OwnerName,
# The source repository name.
[Parameter(Position=1,Mandatory=$true)][string] $RepositoryName,
# The destination repository's owner name.
[Parameter(ValueFromPipelineByPropertyName=$true)][Alias('owner')][string] $DestinationOwnerName = $OwnerName,
# The destination repository name.
[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Alias('name')][string] $DestinationRepositoryName,
<#
Determines the copy behavior:
* AddNew: Insert new labels from the source.
* AddAndUpdate: Insert new labels from the source, and also overwrite attributes from matching labels in the source.
* ReplaceAll: Insert new labels from the source, overwrite attributes from matching labels in the source, and delete
  any labels that don't exist in the source.
#>
[ValidateSet('AddAndUpdate','AddNew','ReplaceAll')][string] $Mode = 'AddAndUpdate'
)
Begin
{
	[pscustomobject[]] $source = Get-GitHubLabel -OwnerName $OwnerName -RepositoryName $RepositoryName
}
Process
{
	$destination = @{ OwnerName = $DestinationOwnerName; RepositoryName = $DestinationRepositoryName }
	[pscustomobject[]] $labels = Get-GitHubLabel @destination
	$source |Where-Object LabelName -NotIn $labels.LabelName |
		ForEach-Object {New-GitHubLabel @destination -Label $_.name -Color $_.color -Description $_.description}
	if($Mode -ne 'AddNew')
	{
		$source |Where-Object LabelName -In $labels.LabelName |
			ForEach-Object {Set-GitHubLabel @destination -Label $_.name -Color $_.color -Description $_.description}
		if($Mode -eq 'ReplaceAll')
		{
			$labels |Where-Object LabelName -NotIn $source.LabelName |Remove-GitHubLabel @destination
		}
	}
}
