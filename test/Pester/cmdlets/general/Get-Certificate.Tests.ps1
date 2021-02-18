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


Describe 'Basic Tests' {

    It 'Returns something' {
        Get-AzmiCertificate -Certificate "$KV_RO$PEMCERT" | Should -Not -BeNullOrEmpty
    }

    It 'It supports Verbose switch' {
        Get-AzmiCertificate -Certificate "$KV_RO$PEMCERT" -Verbose | Should -Not -BeNullOrEmpty
    }

}

Describe 'Access rights tests against different Key Vaults' {

    It 'Fails on NA Key Vault with cert 1' {
        {Get-AzmiCertificate -Certificate "$KV_NA$PEMCERT"} | Should -Throw
    }

    It 'Works on RO Key Vault with cert 1' {
        {Get-AzmiCertificate -Certificate "$KV_RO$PEMCERT"} | Should -Not -Throw
    }

    It 'Fails on NA Key Vault with cert 2' {
        {Get-AzmiCertificate -Certificate "$KV_NA$PFXCERT"} | Should -Throw
    }

    It 'Works on RO Key Vault with cert 2' {
        {Get-AzmiCertificate -Certificate "$KV_RO$PFXCERT"} | Should -Not -Throw
    }
}

#
#  ⭐ Functional testing ⭐
#


Describe 'Verify returned objects' {

    It 'PEM cert is OK' {
        $cer = Get-AzmiCertificate -Certificate "$KV_RO$PEMCERT"
        $cer.StartsWith('MII') | Should -BeTrue -Because $cer
        $cer.EndsWith('=') | Should -BeTrue -Because $cer
    }

    It 'PFX cert is OK' {
        $cer = Get-AzmiCertificate -Certificate "$KV_RO$PFXCERT"
        $cer.StartsWith('MII') | Should -BeTrue -Because $cer
        $cer.EndsWith('=') | Should -BeTrue -Because $cer
    }

}

Describe 'Writes cert to file' {

    # Test argument -File

    It 'File does not exist initially' {
        Test-Path $testFile | Should -Be $false
    }

    It 'Accepts -File argument' {
        Get-AzmiCertificate -Certificate "$KV_RO$PEMCERT" -File $testFile
    }

    It 'File does exist after command' {
        Test-Path $testFile | Should -Be $true
    }

    It 'File has proper content' {
        $cer = Get-Content $testFile
        $cer.StartsWith('MII') | Should -BeTrue -Because $cer
        $cer.EndsWith('=') | Should -BeTrue -Because $cer
    }

    It 'It overwrites existing file' {
        Get-AzmiCertificate -Certificate "$KV_RO$PEMCERT" -File $testFile
    }

    It 'Removes test file' {
        Remove-Item $testFile -Force
    }


}
