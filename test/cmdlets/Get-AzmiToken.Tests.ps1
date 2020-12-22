BeforeAll {

    $moduleName = 'azmi'
    $commandName = 'Get-AzmiToken'
    $managedIdentityName = 'azmitest'


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

Describe 'Basic tests'  {

    It 'It returns something' {
        Get-AzmiToken  | Should -Not -BeNullOrEmpty
    }

    It 'It accepts JWTformat switch' {
        Get-AzmiToken -JWTformat | Should -Not -BeNullOrEmpty
    }

    It 'It accepts JWTformat switch' {
        Get-AzmiToken -JWTformat | Should -Contain $managedIdentityName
    }

}

Describe 'Identity argument'  {

    It 'It works with proper ID' {
        # add ID as pipeline variable first
        # Get-AzmiToken  | Should -Not -BeNullOrEmpty
    }

    It 'It fails with fake ID' {
        {Get-AzmiToken -Identity fakeIdentity}| Should -Throw
    }

}