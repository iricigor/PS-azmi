    #
    # Pester tests for Get-AzmiToken.cs
    #
    #   Returns Azure access token for a managed identity
    #


BeforeAll {

    $moduleName = 'azmi'
    $commandName = 'Get-AzmiToken'
    $managedIdentityName = 'azmitest'

    # import environment variables
    $MSI = $Env:IDENTITY_CLIENT_ID

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
        Get-AzmiToken | Should -Not -BeNullOrEmpty
    }

    It 'It accepts JWTformat switch' {
        Get-AzmiToken -JWTformat | Should -Not -BeNullOrEmpty
    }

    It 'In JWT you can see identity' {
        (Get-AzmiToken -JWTformat).Contains($managedIdentityName) | Should -Be $true
    }

}

Describe 'Identity argument'  {

    It 'It works with proper ID' {
        Get-AzmiToken -Identity $MSI | Should -Not -BeNullOrEmpty
    }

    It 'It fails with fake ID' {
        {Get-AzmiToken -Identity fakeIdentity}| Should -Throw
    }

}