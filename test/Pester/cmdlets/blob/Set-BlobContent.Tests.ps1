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
    $StorageAccountURL = "https://$STORAGEACCOUNTNAME.blob.core.windows.net"
    $CONTAINER_NA="$StorageAccountURL/azmi-na"
    $CONTAINER_RO="$StorageAccountURL/azmi-ro"
    $CONTAINER_RW="$StorageAccountURL/azmi-rw"
    $CONTAINER_LB="$StorageAccountURL/azmi-ls"


    if (!(Get-Module $moduleName)) {
        throw "You must import module before running tests."
    }

    # remember current location
    $firstLoc = Get-Location
}

AfterAll {
    Set-Location $firstLoc
}


#
#  ⭐ non Functional testing ⭐
#


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

    It 'Function has identity argument' {
        $P = (Get-Command $commandName -Module $moduleName).Parameters
        $P.Identity | Should -Not -BeNullOrEmpty
    }
}

#
#  ⭐ Basic and Access handling tests ⭐
#

Describe "Basic Tests" {

    It 'Successfully uploads file on RW container' {
        {Set-AzmiBlobContent -File $testFile1 -Blob "$CONTAINER_RW/test.txt"} | Should -Not -Throw
    }

    It 'Supports Verbose switch' {
        {Set-AzmiBlobContent -File $testFile1 -Blob "$CONTAINER_RW/test.txt" -Force -Verbose} | Should -Not -Throw
    }

    It 'Clears uploaded file' {
        {Get-AzmiBlobContent -Blob "$CONTAINER_RW/test.txt" -File $testFile2 -DeleteAfterCopy} | Should -Not -Throw
        {Remove-Item $testFile2 -Force} | Should -Not -Throw
    }

}

Describe 'Single file upload against different containers'  {

    It 'Fails to upload file on NA container' {
        {Set-AzmiBlobContent -File $testFile1 -Blob "$CONTAINER_NA/test.txt"} | Should -Throw
    }

    It 'Fails to upload file on RO container' {
        {Set-AzmiBlobContent -File $testFile1 -Blob "$CONTAINER_RO/test.txt"} | Should -Throw
    }

    It 'Successfully uploads file on RW container' {
        {Set-AzmiBlobContent -File $testFile1 -Blob "$CONTAINER_RW/test.txt" -Force} | Should -Not -Throw
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
        {Set-AzmiBlobContent -Directory $testDir -Container $CONTAINER_RW -Force} | Should -Not -Throw
    }
}


#
#  ⭐ Functional testing ⭐
#


Describe 'Single file upload verification'  {

    # TODO: Think of independent tests, these four tests should be a single test with multiple Asserts
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

Describe 'Multiple files upload verification'  {

    It 'Verify count of uploaded file' {
        Get-AzmiBlobList -Container $CONTAINER_RW | Should  -HaveCount 3
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
        {Get-AzmiBlobContent -Blob "$CONTAINER_RW/test1.txt" -File $testFile3} | Should -Throw
    }
}


Describe 'Upload file with force' {

    # Testing parameter -Filter

    It 'Uploads file to empty container' {
        {Set-AzmiBlobContent -File $testFile1 -Blob "$CONTAINER_RW/test.txt"} | Should -Not -Throw
    }

    It 'Uploads the same file fails' {
        {Set-AzmiBlobContent -File $testFile1 -Blob "$CONTAINER_RW/test.txt"} | Should -Throw
    }

    It 'Uploads with force is OK' {
        {Set-AzmiBlobContent -File $testFile1 -Blob "$CONTAINER_RW/test.txt" -Force} | Should -Not -Throw
    }

    It 'Deletes uploaded file' {
        {Get-AzmiBlobContent -Blob "$CONTAINER_RW/test.txt" -File $testFile3 -DeleteAfterCopy} | Should -Not -Throw
    }
}

Describe 'Upload filtered list of files' {

    # Testing parameter -Filter

    It 'Confirm local file exists' {
        Get-ChildItem -Path $testDir -Filter 'test2.txt' | Should -Not -BeNullOrEmpty
    }

    It 'Successfully uploads directory to RW container' {
        {Set-AzmiBlobContent -Directory $testDir -Container $CONTAINER_RW -Exclude 'test2.txt'} | Should -Not -Throw
    }

    It 'Verify count of uploaded file' {
        Get-AzmiBlobList -Container $CONTAINER_RW | Should  -HaveCount 2
    }

    It 'Successfully deletes uploaded files' {
        {Get-AzmiBlobContent -Container $CONTAINER_RW -Directory $subDir -DeleteAfterCopy} | Should -Not -Throw
    }

}