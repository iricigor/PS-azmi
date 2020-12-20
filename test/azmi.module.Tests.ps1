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

    It 'Has functions imported' {
        Get-Command -Module $moduleName | Should -Not -BeNullOrEmpty
    }

}