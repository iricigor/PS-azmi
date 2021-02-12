    #
    # Pester tests for Get-AzmiKeyVaultSecret.cs
    #
    #   Lists secrets from Azure Key Vault using managed identity
    #


BeforeAll {

    $moduleName = 'azmi'
    $commandName = 'Get-AzmiSecret'
    $managedIdentityName = 'azmitest'

    # import environment variables
    $MSI = $Env:IDENTITY_CLIENT_ID
    $KEY_VAULTS_BASE_NAME = $Env:KEY_VAULTS_BASE_NAME

    # calculated values
    $KV_NA="https://$KEY_VAULTS_BASE_NAME-na.vault.azure.net"
    $KV_RO="https://$KEY_VAULTS_BASE_NAME-ro.vault.azure.net"
    $SecretRO = "$KV_RO/secrets/secret1"
    $SecretNA = "$KV_NA/secrets/secret1"

    $testFile = Join-Path $TestDrive 'secret.txt'

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

    It 'Has $KEY_VAULTS_BASE_NAME defined' {
        $KEY_VAULTS_BASE_NAME | Should  -Not -BeNullOrEmpty
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
        Get-AzmiSecret -Secret $SecretRO | Should -Not -BeNullOrEmpty
    }

    It 'It supports Verbose switch' {
        Get-AzmiSecret  -Secret $SecretRO -Verbose | Should -Not -BeNullOrEmpty
    }
}

Describe 'Access rights tests against different Key Vaults' {

    It 'Fails on NA Key Vault' {
        {Get-AzmiSecret -Secret $SecretNA} | Should -Throw
    }

    It 'Works on RO Key Vault' {
        {Get-AzmiSecret -Secret $SecretRO} | Should -Not -Throw
    }
}


#
#  ⭐ Functional testing ⭐
#


Describe 'Wrong secret URL tests' {

    It 'It fails on non-existing secret' {
        {Get-AzmiSecret -Secret 'non-existing'} | Should -Throw
    }

    It 'It fails on missing secret in existing KV' {
        {Get-AzmiSecret -Secret "$KV_RO/secrets/missingsecret"} | Should -Throw
    }

    It 'It fails on wrongly formatted URL' { # missing URL part /secrets/
        {Get-AzmiSecret -Secret "$KV_RO/secret1"} | Should -Throw
    }

}

Describe 'Content tests'  {

    It 'It returns proper value' {
        Get-AzmiSecret -Secret $SecretRO | Should -Be 'version2'
    }

    # add test for previous version which should return 'version1'

}

Describe 'File export'  {

    It 'File does not exist initially' {
        Test-Path $testFile | Should -Be $false
    }

    It 'Accepts -File argument' {
        Get-AzmiSecret -Secret $SecretRO -File $testFile
    }

    It 'File does exist after command' {
        Test-Path $testFile | Should -Be $true
    }

    It 'File has proper content' {
        Get-Content $testFile | Should -Be 'version2'
    }

    It 'It overwrites existing file' {
        Get-AzmiSecret -Secret $SecretRO -File $testFile
    }

    It 'Removes test file' {
        Remove-Item $testFile -Force
    }


}


