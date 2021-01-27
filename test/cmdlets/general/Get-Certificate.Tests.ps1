    #
    # Pester tests for Get-AzmiKeyVaultSecret.cs
    #
    #   Lists secrets from Azure Key Vault using managed identity
    #


BeforeAll {

    $moduleName = 'azmi'
    $commandName = 'Get-AzmiCertificate'
    $managedIdentityName = 'azmitest'

    # import environment variables
    $MSI = $Env:IDENTITY_CLIENT_ID
    $KEY_VAULTS_BASE_NAME = $Env:KEY_VAULTS_BASE_NAME

    # calculated values
    $KV_NA="https://$KEY_VAULTS_BASE_NAME-na.vault.azure.net"
    $KV_RO="https://$KEY_VAULTS_BASE_NAME-ro.vault.azure.net"

    $PEMCERT='/certificates/pem-cert'
    $PFXCERT='/certificates/pfx-cert'

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

Describe 'Basic Tests' {

    It 'Returns something' {
        Get-AzmiCertificate -Certificate "$KV_RO$PEMCERT" | Should -Not -BeNullOrEmpty
    }
}