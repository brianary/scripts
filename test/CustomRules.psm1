#Requires -Version 7

<#
.SYNOPSIS
Includes functional comment-based help.

.DESCRIPTION
Comment-based help is specially-structured comments that provide details on a script's
purpose, usage, and any limitations or other considerations that would help someone
operate it.

.INPUTS
System.Management.Automation.Language.FunctionDefinitionAst

.OUTPUTS
Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord

.LINK
about_Comment_Based_Help
#>

function Measure-CommentBasedHelpExists
{
	[CmdletBinding()][OutputType([Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]])] Param
	(
		[Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][System.Management.Automation.Language.ScriptBlockAst]
		$ScriptAst
	)
	Begin
	{
		$description = @"
Comment-based help is specially-structured comments that provide details on a script's
purpose, usage, and any limitations or other considerations that would help someone
operate it. See about_Comment_Based_Help.
"@ -replace '[\r\n]',' '
		[ScriptBlock] $predicate = {
			Param(
			[System.Management.Automation.Language.Ast] $Ast
			)
			if ($Ast -is [System.Management.Automation.Language.AttributeAst])
			{
				[System.Management.Automation.Language.AttributeAst] $attrAst = $ast;
				if ($attrAst.TypeName.Name -eq 'CmdletBinding') {return $true}
			}
			return $false
		}
	}
	Process
	{
		$results = @()
		try
		{
			[System.Management.Automation.Language.AttributeAst[]] $attrAsts = $ScriptAst.Find($predicate, $true)
			if ($ScriptAst.IsWorkflow -or !$attrAsts) {return $results}
			if (!$ScriptAst.GetHelpContent())
			{
				$results += New-Object -Typename Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord `
					-ArgumentList $description,$ScriptAst.Extent,$PSCmdlet.MyInvocation.InvocationName,Warning,$null
			}
			return $results
		}
		catch
		{
			$PSCmdlet.ThrowTerminatingError($PSItem)
		}
	}
}

Export-ModuleMember -Function Measure-*
