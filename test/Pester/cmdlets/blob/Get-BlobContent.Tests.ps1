    #
    # Pester tests for Get-AzmiBlobContent.cs
    #
    #   Downloads blob/blobs from Azure storage account to local file/directory using managed identity
    #


BeforeAll {

    $moduleName = 'azmi'
    $commandName = 'Get-AzmiBlobContent'
    $managedIdentityName = 'azmitest'
    $testFile = Join-Path $TestDrive 'test.txt'
    $testDir = Join-Path $TestDrive 'testDir'

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


Describe 'Basic tests'  {

    It 'It returns something' {
        {Get-AzmiBlobContent -Blob "$CONTAINER_RO/file1" -File $testFile} | Should -Not -Throw
    }

    It 'It supports Verbose switch' {
        {Get-AzmiBlobContent -Blob "$CONTAINER_RO/file1" -File $testFile -Verbose} | Should -Not -Throw
    }
}

Describe 'Access rights tests'  {

    It 'Fails on NA blob with single file' {
        {Get-AzmiBlobContent -Blob "$CONTAINER_NA/file1" -File $testFile} | Should -Throw
    }

    It 'Fails on NA blob with multiple files' {
        {Get-AzmiBlobContent -Container "$CONTAINER_NA" -Directory $testDir} | Should -Throw
    }

    It 'Works on RO blob with single file' {
        {Get-AzmiBlobContent -Blob "$CONTAINER_RO/file1" -File $testFile} | Should -Not -Throw
        {Remove-Item $testFile -Force} | Should -Not -Throw
    }

    It 'Works on RO blob with multiple files' {
        {Get-AzmiBlobContent -Container "$CONTAINER_RO" -Directory $testDir} | Should -Not -Throw
        {Remove-Item $testDir -Force -Recurse} | Should -Not -Throw
    }

    # No testing for RW container because
    #   - it does not have files initially, it adds complexity to create and delete files
    #   - it gives the same results as RO directory, it adds no additional value
}


#
#  ⭐ Functional testing ⭐
#


Describe 'Downloads single file properly'  {

    It 'Test drive should exist' {
        Get-Item 'TestDrive:/' | Should -Not -BeNullOrEmpty
    }

    It 'File should not exist initially' {
        $testFile | Should -Not -Exist
    }

    It 'File exists after downloading' {
        Get-AzmiBlobContent -Blob "$CONTAINER_RO/file1" -File $testFile
        $testFile | Should -Exist
        Remove-Item $testFile -Force
    }

    It 'File should contain Ahoj' {
        Get-AzmiBlobContent -Blob "$CONTAINER_RO/file1" -File $testFile
        $testFile | Should -FileContentMatch 'Ahoj!'
        Remove-Item $testFile -Force
    }

    It 'Creates file in current directory' {
        New-Item $testdir -ItemType Directory -Force | Out-Null
        Set-Location $testdir
        Get-AzmiBlobContent -Blob "$container_ro/file1" -File 'test.txt'
        Join-Path $testdir 'test.txt' | Should -Exist
        Set-Location -Path -
        Remove-Item $testdir -Recurse -Force
    }
}


Describe 'Downloads multiple files properly'  {

    It 'Directory is empty or not existing initially' {
        Get-ChildItem $testDir -ea 0 | Should -BeNullOrEmpty
    }

    It 'Creates two files' {
        Get-AzmiBlobContent -Container $CONTAINER_RO -Directory $testDir
        Get-ChildItem $testDir | Should -HaveCount 2
    }

    It 'File should have proper content' {
        Get-AzmiBlobContent -Container $CONTAINER_RO -Directory $testDir -Verbose
        Join-Path $testDir 'file1' | Should -FileContentMatch 'Ahoj!'
        Remove-Item $testdir -Recurse -Force
    }

    It 'Creates directory under current location' {
        New-Item $testDir -ItemType Directory -Force | Out-Null
        Set-Location $testDir
        Get-AzmiBlobContent -Container $CONTAINER_RO -Directory 'testDir'
        $newDir = Join-Path $testDir 'testDir'
        $newDir | Should -Exist

        Get-ChildItem $newDir | Should -HaveCount 2
        Set-Location -Path -
        Remove-Item $testdir -Recurse -Force
    }
}


Describe 'Delete after copy works properly'  {

    It 'Fails on RO container' {
        {Get-AzmiBlobContent -Blob "$CONTAINER_RO/file1" -File $testFile -DeleteAfterCopy} | Should -Throw
    }

    #
    # More tests are done in scope of Set-AzmiBlobContent commandlet tests
    #

}

Describe 'Download filtered blobs properly' {

    It 'Target directory is empty or not existing initially' {
        Remove-Item $testDir -Force -ea 0
        Get-ChildItem $testDir -ea 0 | Should -BeNullOrEmpty
    }

    It 'Creates only one file' {
        Get-AzmiBlobContent -Container $CONTAINER_RO -Directory $testDir -Exclude 'file1'
        Get-ChildItem $testDir | Should -HaveCount 1
    }
}

Describe 'Download blobs with prefix properly' {

    It 'Target directory is empty or not existing initially' {
        Remove-Item $testDir -Force -ea 0
        Get-ChildItem $testDir -ea 0 | Should -BeNullOrEmpty
    }

    It 'Creates only one file' {
        Get-AzmiBlobContent -Container $CONTAINER_RO -Directory $testDir -Prefix 'file1'
        Get-ChildItem $testDir | Should -HaveCount 1
    }
}
