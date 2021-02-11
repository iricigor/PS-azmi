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


#
#  ⭐ non Functional testing ⭐
#


Describe 'Verify required variables'  {
    # in order to avoid weird failures later, we first test if we have required variables
    It 'Has IDENTITY_CLIENT_ID defined' {
        $MSI | Should  -Not -BeNullOrEmpty
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


#
#  ⭐ Basic and Access handling tests ⭐
#


Describe 'Basic tests'  {

    It 'It returns something' {
        Get-AzmiToken | Should -Not -BeNullOrEmpty
    }

    It 'It supports Verbose switch' {
        Get-AzmiToken -Verbose | Should -Not -BeNullOrEmpty
    }
}


#
#  ⭐ Functional testing ⭐
#


Describe 'JWT parameter tests' {

    # Testing parameter -JWTformat

    It 'It accepts JWTformat switch' {
        Get-AzmiToken -JWTformat | Should -Not -BeNullOrEmpty
    }

    It 'In JWT you can see identity' {
        (-join (Get-AzmiToken -JWTformat)).Contains($managedIdentityName) | Should -Be $true
    }

    It 'JWT you can parse back as JSON' {
        Get-AzmiToken -JWTformat | ConvertFrom-Json | Should -Not -BeNullOrEmpty
    }

}

Describe 'Identity argument'  {

    # Testing parameter -Identity

    It 'It works with proper ID' {
        Get-AzmiToken -Identity $MSI | Should -Not -BeNullOrEmpty
    }

    It 'It fails with fake ID' {
        {Get-AzmiToken -Identity fakeIdentity}| Should -Throw
    }

}