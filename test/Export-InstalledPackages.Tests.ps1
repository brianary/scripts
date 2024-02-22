<#
.SYNOPSIS
Tests exporting the list of packages installed by various tools.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Export-InstalledPackages' -Tag Export-InstalledPackages -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
		$installed = @{
			PSModules = 'Get-Module'
			WinGet = 'winget'
			Chocolatey = 'choco'
			#Scoop = 'scoop'
			Npm = 'npm'
			DotNetTools = 'dotnet'
			GitHubExtensions = 'gh'
		}
		@($installed.Keys) |Where-Object {!(Get-Command $_ -ErrorAction Ignore)} |ForEach-Object {$installed.Remove($_)}
		function winget {'{Sources:{Packages:{PackageIdentifier:["WinGet"]}}}' |Out-File "$env:temp\winget.json"}
		#function scoop {[pscustomobject]@{Name='Scoop'}}
		function npm {'{dependencies:{Npm:true}}'}
		Mock Get-Module {[pscustomobject]@{Name='PSModules'}}
		Mock winget {'{Sources:{Packages:{PackageIdentifier:["WinGet"]}}}' |Out-File "$env:temp\winget.json"} -ErrorAction Ignore
		Mock choco {'','Chocolatey',''} -ErrorAction Ignore
		#Mock scoop {[pscustomobject]@{Name='Scoop'}} -ErrorAction Ignore
		Mock npm {'{dependencies:{Npm:true}}'} -ErrorAction Ignore
		Mock dotnet {'','','DotNetTools version'} -ErrorAction Ignore
		Mock gh {'- - GitHubExtensions -'} -ErrorAction Ignore
	}
	Context 'Exports the list of packages installed by various tools' `
		-Tag ExportInstalledPackages,Export,InstalledPackages,Packages {
		It "Queries the installed packages" {
			$packages = Export-InstalledPackages.ps1
			$installed.Values |ForEach-Object {Assert-MockCalled -CommandName $_ -Times 1}
			$packages.Count |Should -BeGreaterThan 0
			#if($packages.ContainsKey('ScoopBuckets')) {$packages.Remove('ScoopBuckets')}
			#$packages.Keys |ForEach-Object {$packages[$_] |Should -BeExactly $_}
		}
	}
}
