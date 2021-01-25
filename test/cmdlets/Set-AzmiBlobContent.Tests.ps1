    #
    # Pester tests for Set-AzmiBlobContent.cs
    #
    #   Uploads local file/directory to Azure storage blob/container using managed identity
    #


BeforeAll {

    $moduleName = 'azmi'
    $commandName = 'Set-AzmiBlobContent'
    $managedIdentityName = 'azmitest'
    $testFile = Join-Path $TestDrive 'test.txt'
    $testFile2 = Join-Path $TestDrive 'test2.txt'
    $testDir = Join-Path $TestDrive 'testDir'
    $testContent = (Get-Date -Format FileDateTimeUniversal) + (Get-Random -Maximum 1000)
    Set-Content -Path $testFile -Value $testContent -Force | Out-Null

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

    # remember current location
    $firstLoc = Get-Location
}

AfterAll {
    Set-Location $firstLoc
}

Describe 'Verify required variables'  {
    # in order to avoid weird test failures later, we first test if we have required variables

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

    $testCases = @(
        @{argName = 'Identity'}
    )     
    It "Function has $argName argument" -TestCases $testCases {
        $P = (Get-Command $commandName -Module $moduleName).Parameters
        $P.ContainsKey($argName) | Should -BeTrue
    }
}


# testing class "setblob"
# test "setblob fails on NA container" assert.Fail "azmi setblob --file $UPLOADFILE --blob ${CONTAINER_NA}/${UPLOADFILE}"
# test "setblob fails on RO container" assert.Fail "azmi setblob --file $UPLOADFILE --blob ${CONTAINER_RO}/${UPLOADFILE}"
# test "setblob OK on RW container" assert.Success "azmi setblob --file $UPLOADFILE --blob ${CONTAINER_RW}/${UPLOADFILE}"

Describe 'Single file upload against different containers'  {

    It 'Fails to upload file on NA container' {
        {Set-AzmiBlobContent -File $testFile -Blob "$CONTAINER_NA/test.txt"} | Should -Throw
    }

    It 'Fails to upload file on RO container' {
        {Set-AzmiBlobContent -File $testFile -Blob "$CONTAINER_RO/test.txt"} | Should -Throw
    }

    It 'Successfully uploads file on RW container' {
        {Set-AzmiBlobContent -File $testFile -Blob "$CONTAINER_RW/test.txt"} | Should -Not -Throw
    }

    It 'Successfully deletes uploaded file on RW container' {
        {Get-AzmiBlobContent -Blob "$CONTAINER_RW/test.txt" -File $testFile2 -DeleteAfterCopy} | Should -Not -Throw
    }


}