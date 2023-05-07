<#
.SYNOPSIS
Adds any missing topics based on repo content.

.FUNCTIONALITY
Git and GitHub
#>

#Requires -Version 7
#Requires -Modules PowerShellForGitHub
[CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')] Param(
[Parameter(Position=0)][scriptblock] $Filter = {$true}
)
Begin
{
    function Add-GitHubRepositoryTopic
    {
        [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
        Param([string] $Owner, [string] $Name, [string[]] $NewTopic, [string[]] $Topics, [psobject] $InputObject)
        if(!($NewTopic |ForEach-Object {$_ -notin $Topics})) {return}
        Write-Verbose "$($MyInvocation.MyCommand.Name) $($PSBoundParameters |ConvertTo-Json -Compress)"
        if(!$PSCmdlet.ShouldProcess("repository $Owner/$Name","add topic '$($NewTopic -join "','")'")) {return}
        $value = ($Topics + $NewTopic).Where({$_ -ne 'missing-topics'})
        Set-GitHubRepositoryTopic -Topic $value -OwnerName $Owner -RepositoryName $Name
        if(Get-Variable GitHubRepos -Scope Global -ErrorAction Ignore) {$InputObject.topics = $value}
    }

    $Global:TopicsChangeList = @()
    function Push-GitHubRepositoryTopic
    {
        [CmdletBinding()] Param([string] $Owner, [string] $Name, [string[]] $NewTopic, [string[]] $Topics, [psobject] $InputObject)
        $Global:TopicsChangeList += $PSBoundParameters
    }

    function Complete-GitHubRepositoryTopic
    {
        $Global:TopicsChangeList |ForEach-Object {Add-GitHubRepositoryTopic @_}
        Remove-Variable TopicsChangeList -Scope Global
    }

    function Get-RepoXml([string] $Filter, [string] $Owner, [string] $Name)
    {
        return & "$PSScriptRoot\Get-GitHubRepoChildItem.ps1" -Path src -Filter $Filter -Recurse -File -OwnerName $Owner `
            -RepositoryName $Name -AlternatePath / |
            ForEach-Object {[xml]((Get-GitHubContent -Path $_.path -OwnerName $Owner -RepositoryName $Name `
                -ResultAsString).contentAsString.Trim(0xFEFF))}
    }

    function Set-AzureFunctionTopic([xml[]] $Projects, [string] $Owner, [string] $Name, [string[]] $Topics, [psobject] $InputObject)
    {
        if('azure-function' -in $Topics) {return} # already there, assume it's right
        [void]$PSBoundParameters.Remove('Projects')
        if(@($Projects |ForEach-Object {Select-Xml /Project/PropertyGroup/AzureFunctionsVersion -Xml $_}).Count -gt 0)
        {
            Push-GitHubRepositoryTopic -NewTopic azure-function @PSBoundParameters
        }
    }

    function Set-CypressTopic([string] $Owner, [string] $Name, [string[]] $Topics, [psobject] $InputObject)
    {
        if('cypress' -in $Topics) {return}
        if(@(& "$PSScriptRoot\Get-GitHubRepoChildItem.ps1" -Filter cypress -Recurse -Directory -OwnerName $Owner `
            -RepositoryName $Name).Count -gt 0)
        {
            Push-GitHubRepositoryTopic -NewTopic cypress @PSBoundParameters
        }
    }

    function Set-DatabaseSchemaTopic([string] $Owner, [string] $Name, [string[]] $Topics, [psobject] $InputObject)
    {
        if('database-schema' -in $Topics) {return}
        if(@(& "$PSScriptRoot\Get-GitHubRepoChildItem.ps1" -Filter *.scpf -File -OwnerName $Owner `
            -RepositoryName $Name).Count -gt 0)
        {
            Push-GitHubRepositoryTopic -NewTopic database-schema @PSBoundParameters
        }
    }

    function Set-FakeTopic([string] $Owner, [string] $Name, [string[]] $Topics, [psobject] $InputObject)
    {
        if('fake' -in $Topics) {return}
        if(@(& "$PSScriptRoot\Get-GitHubRepoChildItem.ps1" -Filter build.fsx -File -OwnerName $Owner `
            -RepositoryName $Name).Count -gt 0)
        {
            Push-GitHubRepositoryTopic -NewTopic fake @PSBoundParameters
        }
    }

    function Set-RedgateSqlChangeAutomationTopic([string] $Owner, [string] $Name, [string[]] $Topics, [psobject] $InputObject)
    {
        if('redgate-sql-change-automation' -in $Topics) {return}
        if(@(& "$PSScriptRoot\Get-GitHubRepoChildItem.ps1" -Filter *.sqlproj -Recurse -File -OwnerName $Owner `
            -RepositoryName $Name).Count -gt 0)
        {
            Push-GitHubRepositoryTopic -NewTopic fake @PSBoundParameters
        }
    }

    function Set-SelfServiceTopic([xml[]] $WebConfigs, [string] $Owner, [string] $Name, [string[]] $Topics, [psobject] $InputObject)
    {
        if('selfservice' -in $Topics -and 'olb-sso' -in $Topics -and 'public-facing' -in $Topics) {return}
        [void]$PSBoundParameters.Remove('WebConfigs')
        if(@($WebConfigs |ForEach-Object {Select-Xml "/configuration/location[@path='api/overlock']" -Xml $_}).Count -gt 0)
        {
            Push-GitHubRepositoryTopic -NewTopic olb-sso,selfservice,public-facing @PSBoundParameters
        }
    }

    function Set-PublicFacingTopic([xml[]] $WebConfigs, [string] $Owner, [string] $Name, [string[]] $Topics, [psobject] $InputObject)
    {
        if('selfservice' -in $Topics -and 'olb-sso' -in $Topics -and 'public-facing' -in $Topics) {return}
        [void]$PSBoundParameters.Remove('WebConfigs')
        if(@($WebConfigs |ForEach-Object {Select-Xml "/configuration/system.web/authentication[@mode='Windows']" -Xml $_}).Count -gt 0)
        {
            Push-GitHubRepositoryTopic -NewTopic public-facing @PSBoundParameters
        }
    }

    filter Add-Topic([Parameter(ValueFromPipelineByPropertyName)][psobject] $Owner,
        [Parameter(ValueFromPipelineByPropertyName)][string] $Name,
        [Parameter(ValueFromPipelineByPropertyName)][string[]] $Topics,
        [Parameter(ValueFromPipeline)][psobject] $InputObject)
    {
        if($PSBoundParameters['Owner'] -isnot [string]) {$PSBoundParameters['Owner'] = $Owner = $Owner.UserName}
        $fullName = "$Owner/$Name"
        Write-Verbose "Adding topics for $fullName"
        $projects = @(Get-RepoXml *.?sproj -Owner $Owner -Name $Name)
        $webConfig = @(Get-RepoXml Web.config -Owner $Owner -Name $Name)
        Set-AzureFunctionTopic -Projects $projects @PSBoundParameters
        Set-CypressTopic @PSBoundParameters
        Set-DatabaseSchemaTopic @PSBoundParameters
        Set-FakeTopic @PSBoundParameters
        Set-RedgateSqlChangeAutomationTopic @PSBoundParameters
        Set-SelfServiceTopic -WebConfigs $webConfig @PSBoundParameters
        Set-PublicFacingTopic -WebConfigs $webConfig @PSBoundParameters
    }
}
Process
{
    Get-GitHubRepos.ps1 |Where-Object $Filter |ForEach-Progress.ps1 'Adding topics to repos' {$_.name} {$_ |Add-Topic}
    Complete-GitHubRepositoryTopic
}
