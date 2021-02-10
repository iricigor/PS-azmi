    #
    # Pester tests for Get-AzmiBlobList.cs
    #
    #   Lists blobs from Azure storage account container using managed identity
    #


BeforeAll {

    $moduleName = 'azmi'
    $commandName = 'Get-AzmiBlobList'
    $managedIdentityName = 'azmitest'

    # import environment variables
    $MSI = $Env:IDENTITY_CLIENT_ID
    $STORAGEACCOUNTNAME = $Env:STORAGE_ACCOUNT_NAME

    # calculated variables
    $CONTAINER_NA="https://$STORAGEACCOUNTNAME.blob.core.windows.net/azmi-na"
    $CONTAINER_RO="https://$STORAGEACCOUNTNAME.blob.core.windows.net/azmi-ro"
    $CONTAINER_RW="https://$STORAGEACCOUNTNAME.blob.core.windows.net/azmi-rw"
    $CONTAINER_LB="https://$STORAGEACCOUNTNAME.blob.core.windows.net/azmi-ls"


    if (!(Get-Module $moduleName)) {
        throw "You must import module before running tests."
    }
}


#
#  📃 non Functional testing 📃
#


Describe 'Verify required variables'  {
    # in order to avoid weird failures later, we first test if we have required variables

    It 'Has IDENTITY_CLIENT_ID defined' {
        $MSI | Should  -Not -BeNullOrEmpty
    }

    It 'Has STORAGE_ACCOUNT_NAME defined' {
        $STORAGEACCOUNTNAME | Should  -Not -BeNullOrEmpty
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

    # sometimes these test throw CredentialUnavailableException
    #  ManagedIdentityCredential authentication unavailable. No Managed Identity endpoint found.

    It 'It returns something' {
        Get-AzmiBlobList -Container $CONTAINER_LB | Should -Not -BeNullOrEmpty
    }

    It 'It supports Verbose switch' {
        Get-AzmiBlobList -Container $CONTAINER_LB -Verbose | Should -Not -BeNullOrEmpty
    }
}


#
#  ⭐ Functional testing ⭐
#


Describe 'Identity argument'  {

    It 'It works with default ID' {
        Get-AzmiBlobList -Container $CONTAINER_LB | Should -Not -BeNullOrEmpty
    }

    It 'It works with proper ID' {
        Get-AzmiBlobList -Container $CONTAINER_LB -Identity $MSI | Should -Not -BeNullOrEmpty
    }

    It 'It fails with fake ID' {
        {Get-AzmiToken -Container $CONTAINER_LB -Identity fakeIdentity}| Should -Throw
    }
}

Describe 'Container argument'  {

    It 'It works with proper container' {
        Get-AzmiBlobList -Container $CONTAINER_LB | Should -Not -BeNullOrEmpty
    }

    It 'It fails with not accessible container' {
        {Get-AzmiBlobList -Container $CONTAINER_NA}| Should -Throw
    }

    It 'It fails with wrong container url' {
        {Get-AzmiBlobList -Container 'random_text'}| Should -Throw
    }

}

Describe 'Verify return values'  {

    It 'It returns 5 blobs' {
        Get-AzmiBlobList -Container $CONTAINER_LB | Should  -HaveCount 5
    }

    # return objects should be
    # server1-file1
    # server1-file2
    # server1-file3
    # server2-file1
    # server2-file2

    It 'Verify proper blob names' {
        $BlobNames = Get-AzmiBlobList -Container $CONTAINER_LB
        $BlobNames | % {$_ | Should -Match 'server\d-file\d'}
    }
}
