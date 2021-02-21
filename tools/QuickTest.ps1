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
try {Get-AzmiToken}
catch [Azure.Identity.CredentialUnavailableException] {}

try {Get-AzmiToken -JWTformat}
catch [Azure.Identity.CredentialUnavailableException] {}

$url = 'https://mystorage.blob.core.windows.net/container/file'
try {Get-AzmiBlobContent $url}
catch [Azure.Identity.CredentialUnavailableException] {

try {Get-AzmiBlobList $url}
catch [Azure.Identity.CredentialUnavailableException] {

Write-Output "All good"
