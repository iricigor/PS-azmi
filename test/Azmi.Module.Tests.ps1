BeforeAll {

    $moduleName = 'azmi'
    if (!(Get-Module $moduleName)) {
        throw "You must import module before running tests."
    }
}



Describe 'Module import verifications'  {

    It 'Has module loaded' {
        Get-Module $moduleName | Should -Not -BeNullOrEmpty
    }

    $TestCases = @(
        @{Name = 'Author'}
        @{Name = 'Description'}
        @{Name = 'Version'}
    )
    It 'Module has required properties defined' -TestCases $TestCases {
        Get-Module $moduleName | Select -Expand $Name | Should -Not -BeNullOrEmpty
    }
}

Describe "Commandlets import verification" {

    It 'Has cmdlets imported' {
        Get-Command -Module $moduleName | Should -Not -BeNullOrEmpty
    }

    It 'All cmdlets should have azmi in the name' {
        $Cmdlets = Get-Command -Module $moduleName
        $MatchingCmdlets = $Cmdlets | where Name -Match '-Azmi'
        $MatchingCmdlets | Should -HaveCount $Cmdlets.Count
    }
}


#
# Check if documentation is proper
#

Describe 'Proper Documentation' {

	It 'Update documentation and git diff should be null' {
        if (!(Get-Module platyPS -List -ea 0)) {Install-Module platyPS -Force -Scope CurrentUser}
		Import-Module platyPS
		# update documentation
		Push-Location -Path $root
        Update-MarkdownHelp -Path .\docs
        New-ExternalHelp -Path .\docs -OutputPath .\en-US -Force
        $diff = git diff .\docs .\en-US
        Pop-Location
		$diff | Should -Be $null
	}

    It 'Verifies documentation for blank descriptors' {
        Select-String -Path '.\docs\*.md' -Pattern '{{.+}}' | Should -BeNullOrEmpty
    }

}
