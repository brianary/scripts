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
			psmodules       = 'Get-Module'
			winget          = 'winget'
			choco           = 'choco'
			'scoop-buckets' = 'scoop'
			npm             = 'npm'
			'dotnet-tools'  = 'dotnet'
			'gh-extensions' = 'gh'
		}
		@($installed.Keys) |Where-Object {!(Get-Command $_ -ErrorAction Ignore)} |ForEach-Object {$installed.Remove($_)}
		function winget {'{Sources:{Packages:{PackageIdentifier:["winget"]}}}' |Out-File "$([io.path]::GetTempPath())\winget.json"}
		function scoop {[pscustomobject]@{Name='scoop'}}
		function npm {'{dependencies:{npm:true}}'}
		Mock Get-Module {[pscustomobject]@{Name='psmodules'}}
		Mock winget {'{Sources:{Packages:{PackageIdentifier:["winget"]}}}' |Out-File "$([io.path]::GetTempPath())\winget.json"} -ErrorAction Ignore
		Mock choco {'','choco',''} -ErrorAction Ignore
		Mock scoop {[pscustomobject]@{Name='scoop'}} -ErrorAction Ignore
		Mock npm {'{dependencies:{npm:true}}'} -ErrorAction Ignore
		Mock dotnet {'','','dotnet-tools version'} -ErrorAction Ignore
		Mock gh {'- - gh-extensions -'} -ErrorAction Ignore
	}
	Context 'Exports the list of packages installed by various tools' `
		-Tag ExportInstalledPackages,Export,InstalledPackages,Packages {
		It "Queries the installed packages" {
			$packages = Export-InstalledPackages.ps1
			$installed.Values |ForEach-Object {Assert-MockCalled -CommandName $_ -Times 1}
			$packages.Count |Should -BeGreaterThan 0
			if($packages.ContainsKey('scoopBuckets')) {$packages.Remove('scoopBuckets')}
			$packages.Keys |ForEach-Object {$packages[$_] |Should -BeExactly $_}
		}
	}
}
