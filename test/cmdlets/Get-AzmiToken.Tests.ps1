BeforeAll {

    $moduleName = 'azmi'
    $commandName = 'Get-AzmiToken'
    if (!(Get-Module $moduleName)) {
        throw "You must import module before running tests."
    }
}



Describe 'Function import verifications'  {

    It 'Has function imported' {
        Get-Command $commandName -Module $moduleName | Should -Not -BeNullOrEmpty
    }

    It 'Function has identity argument' {
        $P = (Get-Command $commandName -Module $moduleName).Parameters
        $P.Identity | Should -Not -BeNullOrEmpty
    }

}