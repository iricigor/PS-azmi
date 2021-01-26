    #
    # Pester tests for Set-AzmiBlobContent.cs
    #
    #   Uploads local file/directory to Azure storage blob/container using managed identity
    #


BeforeAll {

    $moduleName = 'azmi'
    $commandName = 'Set-AzmiBlobContent'
    $managedIdentityName = 'azmitest'

    # prepare the environment on test drive
    $testDir = Join-Path $TestDrive 'testDir'
    $subDir = Join-Path $testDir 'testSubDir'
    $testFile1 = Join-Path $testDir 'test1.txt'
    $testFile2 = Join-Path $testDir 'test2.txt'
    $testFile3 = Join-Path $subDir 'test3.txt'
    $testContent = (Get-Date -Format FileDateTimeUniversal) + (Get-Random -Maximum 1000)
    # create directories and files
    New-Item $testDir -ItemType Directory | Out-Null
    New-Item $subDir -ItemType Directory | Out-Null
    Set-Content -Path $testFile1 -Value $testContent -Force | Out-Null
    Set-Content -Path $testFile2 -Value null -Force | Out-Null
    Set-Content -Path $testFile3 -Value null -Force | Out-Null

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


Describe 'Single file upload against different containers'  {

    It 'Fails to upload file on NA container' {
        {Set-AzmiBlobContent -File $testFile1 -Blob "$CONTAINER_NA/test.txt"} | Should -Throw
    }

    It 'Fails to upload file on RO container' {
        {Set-AzmiBlobContent -File $testFile1 -Blob "$CONTAINER_RO/test.txt"} | Should -Throw
    }

    # TODO: Think of independent tests, these four tests should be a single test with multiple Asserts
    It 'Successfully uploads file on RW container' {
        {Set-AzmiBlobContent -File $testFile1 -Blob "$CONTAINER_RW/test.txt"} | Should -Not -Throw
    }

    It 'Verify content of uploaded file' {
        $testFile2 | Should -Not -FileContentMatch $testContent
        Get-AzmiBlobContent -Blob "$CONTAINER_RW/test.txt" -File $testFile2
        $testFile2 | Should -FileContentMatch $testContent
    }

    It 'Successfully deletes uploaded file' {
        {Get-AzmiBlobContent -Blob "$CONTAINER_RW/test.txt" -File $testFile2 -DeleteAfterCopy} | Should -Not -Throw
    }

    It 'Fails to download deleted file' {
        {Get-AzmiBlobContent -Blob "$CONTAINER_RW/test.txt" -File $testFile2} | Should -Throw
    }

}


Describe 'Multiple files upload against different containers'  {

    It 'Fails to upload directory to NA container' {
        {Set-AzmiBlobContent -Directory $testDir -Container $CONTAINER_NA} | Should -Throw
    }

    It 'Fails to upload directory to RO container' {
        {Set-AzmiBlobContent -Directory $testDir -Container $CONTAINER_RO} | Should -Throw
    }

    It 'Successfully uploads directory to RW container' {
        {Set-AzmiBlobContent -Directory $testDir -Container $CONTAINER_RW} | Should -Not -Throw
    }

    It 'Verify count of uploaded file' {
        Get-AzmiBlob -Container $CONTAINER_RW | Should  -HaveCount 3
    }

    It 'Verify content of uploaded file' {
        $testFile3 | Should -Not -FileContentMatch $testContent
        Get-AzmiBlobContent -Blob "$CONTAINER_RW/test1.txt" -File $testFile3
        $testFile3 | Should -FileContentMatch $testContent
    }

    It 'Successfully deletes multiple files' {
        {Get-AzmiBlobContent -Container $CONTAINER_RW -Directory $subDir -DeleteAfterCopy} | Should -Not -Throw
    }

    It 'Fails to download deleted file' {
        # the same command as above should now fail
        {Get-AzmiBlobContent -Container $CONTAINER_RW -Directory $subDir -DeleteAfterCopy} | Should -Throw
    }


}


