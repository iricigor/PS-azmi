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

    It 'Has cmdlets imported' {
        Get-Command -Module $moduleName | Should -Not -BeNullOrEmpty
    }

    It 'All cmdlets should have azmi in the name' {
        $Cmdlets = Get-Command -Module $moduleName
        $MatchingCmdlets = $Cmdlets | where Name -Match '-Azmi'
        $MatchingCmdlets.Count | Should -HaveCount $Cmdlets.Count
    }

}
