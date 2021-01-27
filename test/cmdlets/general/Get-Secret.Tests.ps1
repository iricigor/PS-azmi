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
    $Secret1 = "$KV_RO/secrets/secret1"

    if (!(Get-Module $moduleName)) {
        throw "You must import module before running tests."
    }
}

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


Describe 'Basic tests'  {

    It 'It returns something' {
        Get-AzmiSecret -Secret $Secret1 | Should -Not -BeNullOrEmpty
    }

    It 'It supports Verbose switch' {
        Get-AzmiSecret  -Secret $Secret1 -Verbose | Should -Not -BeNullOrEmpty
    }

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
        Get-AzmiSecret -Secret $Secret1 | Should -Be 'version2'
    }

    # add test for previous version which should return 'version1'


}
