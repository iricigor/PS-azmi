param (

    [Parameter()][string]$ModuleName = 'azmi',

    [Parameter()][string]$ModulePath = '.'
    # location where module folder is location, not the module itself
    # folder name must be the same as module name!
)

#$ModuleName = 'azmi'
#$ModulePath = './azmi'

# check if the key is defined as environment variable
$Key = $env:MyPSGalleryAPIKey
if ($Key.Length -gt 10) {
    Write-Host "Key with length $($Key.Length) found, it starts with $($Key.Substring(0,3))"
} else {
    throw "Key not found"
}

# check if local module version already exists
$FileName = "${ModuleName}.psd1"
$ModulePath = Join-Path $ModulePath $ModuleName
Set-Location -Path $ModulePath # we will later publish from current folder
$Manifest = Test-ModuleManifest $FileName
$LocalVersion = $Manifest.Version.ToString()

try {
    $RemoteModule = Find-Module $ModuleName -Repository PSGallery
    $RemoteVersion = $RemoteModule.Version.ToString()
} catch {
    $RemoteVersion = 'not found'
}

if ($LocalVersion -eq $RemoteVersion) {
    Write-Warning "Module $ModuleName with version $LocalVersion already exists. Consider bumping version."
    exit
}

# we proceed with publish
Write-Output "Publishing version $LocalVersion to PSGallery, currently published version is $RemoteVersion"
try {
    Publish-Module -Path . -Repository PSGallery -NuGetApiKey $Key -ea Stop -Verbose
    Write-Output "Module successfully published!"
} catch {
    Write-Output "Publishing failed: $_"
}
