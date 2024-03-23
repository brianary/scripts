<#
.SYNOPSIS
Tests searching installed programs.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Find-InstalledPrograms' -Tag Find-InstalledPrograms -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Searches installed programs' -Tag FindInstalledPrograms,Find,InstalledPrograms,Programs {
		It "Finds PowerShell installation" {
			Mock Get-CimInstance {[pscustomobject]@{
				AssignmentType = 1us
				Caption = 'PowerShell 7-x64'
				Description = 'PowerShell 7-x64'
				ElementName = $null
				HelpLink = 'https://github.com/PowerShell/PowerShell'
				HelpTelephone = $null
				IdentifyingNumber = '{B06D1894-3827-4E0C-A092-7DC50BE8B210}'
				InstallDate = '20240113'
				InstallDate2 = $null
				InstallLocation = $null
				InstallSource = 'C:\Users\brian\AppData\Local\Temp\chocolatey\powershell-core\7.4.1\'
				InstallState = 5s
				InstanceID = $null
				Language = '1033'
				LocalPackage = 'C:\WINDOWS\Installer\8034b0b4.msi'
				Name = 'PowerShell 7-x64'
				PackageCache = 'C:\WINDOWS\Installer\8034b0b4.msi'
				PackageCode = '{79F7FC03-0E49-40C3-BDA9-1EABB8C2EE58}'
				PackageName = 'PowerShell-7.4.1-win-x64.msi'
				ProductID = $null
				PSComputerName = $null
				RegCompany = $null
				RegOwner = $null
				SKUNumber = $null
				Transforms = $null
				URLInfoAbout = $null
				URLUpdateInfo = $null
				Vendor = 'Microsoft Corporation'
				Version = '7.4.1.0'
				WarrantyDuration = $null
				WarrantyStartDate = $null
				WordCount = 0u
			}}
			$found = Find-InstalledPrograms.ps1 %powershell%
			$found.Name |Should -BeExactly 'PowerShell 7-x64'
			$found.Caption |Should -BeExactly 'PowerShell 7-x64'
			$found.Vendor |Should -BeExactly 'Microsoft Corporation'
		}
	}
}
