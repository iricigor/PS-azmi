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
}


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

    It 'It returns something' {
        {Get-AzmiBlobContent -Blob "$CONTAINER_RO/file1" -File $testFile} | Should -Not -Throw
    }

    It 'It supports Verbose switch' {
        {Get-AzmiBlobContent -Blob "$CONTAINER_RO/file1" -File $testFile -Verbose} | Should -Not -Throw
    }

    It 'Fails on no access blob with single file' {
        {Get-AzmiBlobContent -Blob "$CONTAINER_NA/file1" -File $testFile} | Should -Throw
    }

    It 'Fails on no access blob with multiple files' {
        {Get-AzmiBlobContent -Container "$CONTAINER_NA" -Directory $testDir} | Should -Throw
    }
}

Describe 'Downloads single file properly'  {

    It 'Test drive should exist' {
        Get-Item 'TestDrive:/' | Should -Not -BeNullOrEmpty
    }

    It 'File should not exist initially' {
        $testFile | Should -Not -Exist
    }

    It 'File exists' {
        Get-AzmiBlobContent -Blob "$CONTAINER_RO/file1" -File $testFile
        $testFile | Should -Exist
    }

    It 'File should contain Ahoj' {
        Get-AzmiBlobContent -Blob "$CONTAINER_RO/file1" -File $testFile
        $testFile | Should -FileContentMatch 'Ahoj!'
    }

    It 'Creates file in current directory' {
        New-Item $testDir -ItemType Directory -Force | Out-Null
        Set-Location $testDir
        Get-AzmiBlobContent -Blob "$CONTAINER_RO/file1" -File 'test.txt'
        Join-Path $testDir 'test.txt' | Should -Exist
        Set-Location -Path '-' # Pop-Location, Pester requirement to get out of TestDrive
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

    It 'Files should have proper content' {
        Get-AzmiBlobContent -Container $CONTAINER_RO -Directory $testDir -Verbose
        Get-Content (Join-Path $testDir 'file1')  | Should -FileContentMatch 'Ahoj!'
        Get-Content (Join-Path $testDir 'file2')  | Should -FileContentMatch 'Ahoj!'
    }

    It 'Creates directory under current location' {
        New-Item $testDir -ItemType Directory -Force | Out-Null
        Set-Location $testDir
        Get-AzmiBlobContent -Container $CONTAINER_RO -Directory 'testDir'
        $newDir = Join-Path $testDir 'testDir'

        $newDir | Should -Exist
        Get-ChildItem $newDir | Should -HaveCount 2
        Set-Location -Path '-' # Pop-Location, Pester requirement to get out of TestDrive
    }

}
