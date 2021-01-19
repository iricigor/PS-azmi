    #
    # Pester tests for Get-AzmiBlob.cs
    #
    #   Lists blobs from Azure storage account container using managed identity
    #


BeforeAll {

    $moduleName = 'azmi'
    $commandName = 'Get-AzmiBlob'
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
        Get-AzmiBlob  | Should -Not -BeNullOrEmpty
    }
}


Describe 'Identity argument'  {

    It 'It works with default ID' {
        Get-AzmiBlob -Container $CONTAINER_LB | Should -Not -BeNullOrEmpty
    }

    It 'It works with proper ID' {
        Get-AzmiBlob -Container $CONTAINER_LB -Identity $MSI | Should -Not -BeNullOrEmpty
    }

    It 'It fails with fake ID' {
        {Get-AzmiToken -Container $CONTAINER_LB -Identity fakeIdentity}| Should -Throw
    }

}

Describe 'Container argument'  {

    It 'It works with proper container' {
        Get-AzmiBlob -Container $CONTAINER_LB | Should -Not -BeNullOrEmpty
    }

    It 'It fails with not accessible container' {
        {Get-AzmiBlob -Container $CONTAINER_NA}| Should -Throw
    }

    It 'It fails with wrong container url' {
        {Get-AzmiBlob -Container 'random_text'}| Should -Throw
    }

}
