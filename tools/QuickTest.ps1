[CmdletBinding()]
param (
    [Parameter(Mandatory=$false,Position=0)][int]$RequiredVersion,
    [Parameter()][string]$Path = './publish',
    [Parameter()][string]$Module = 'azmi'
)

# Quick test for the module, just import and verify commands
# It works also on machines without managed identity

Write-Output "PSVersionTable"
$PSVersionTable

if (!$RequiredVersion) {
    Write-Warning 'Please specify required PowerShell version as argument -RequiredVersion'
} elseif ($PSVersionTable.PSVersion.Major -ne $RequiredVersion) {
    Write-Warning "PowerShell required version mismatch, expected $RequiredVersion, found $($PSVersionTable.PSVersion.Major)"
} else {
    Write-Output "PowerShell required version as expected - $RequiredVersion"
}

$FullPath = Join-Path $Path $Module
Write-Output "Import module $FullPath"
Import-Module $FullPath

Write-Output "Check commands $FullPath"
Get-Command -module $Module | Select CommandType, Name, Version | Format-Table

Write-Output "Check syntax $FullPath"
Get-Command -module $Module | % {
    "$('='*40)`n$_`n"
    Get-Help $_ | % {$_.Syntax.syntaxItem.parameter}
}

Write-Output "Check commands execution"
Write-Output "Get-AzmiToken"
try {Get-AzmiToken}
catch [Azure.Identity.CredentialUnavailableException] {}

Write-Output "Get-AzmiToken -JWTformat"
try {Get-AzmiToken -JWTformat}
catch [Azure.Identity.CredentialUnavailableException] {}

$url = 'https://mystorage.blob.core.windows.net/container/file'
Write-Output "Get-AzmiBlobContent"
try {Get-AzmiBlobContent $url}
catch [Azure.Identity.CredentialUnavailableException] {}

Write-Output "Get-AzmiBlobList"
try {Get-AzmiBlobList $url}
catch [Azure.Identity.CredentialUnavailableException] {}

Write-Output "Set-AzmiBlobContent"
$fileName = (New-TemporaryFile).FullName
try {Set-AzmiBlobContent $url $fileName}
catch [Azure.Identity.CredentialUnavailableException] {}

$KV = 'https://key.vault.azure.net/'
Write-Output "Get-AzmiSecret"
try {Get-AzmiSecret "${KV}secrets/secret"}
catch [Azure.Identity.CredentialUnavailableException] {}

Write-Output "Get-AzmiCertificate"
try {Get-AzmiCertificate "${KV}certificates/cert"}
catch [Azure.Identity.CredentialUnavailableException] {}

Remove-Item $fileName -Force -ea 0
Write-Output "All good"
