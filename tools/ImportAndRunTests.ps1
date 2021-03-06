param (
	# we need to import secret variable like this
	[string]$MSI
)

# module can be compiled (published) in previous step or even on different machine
$modulePath = './publish/azmi.psd1'

if (get-item $modulePath -ea 0) {
	Write-Output "Import azmi module"
	Import-Module $modulePath -Force
} else {
	Write-Output "azmi module not found, searching for it..."
	Get-ChildItem -Recurse
	exit 1
}


if (!(Get-Module 'Pester' -List | ? Version -ge 5.0.0)) {
	Write-Output "Install Pester 5 module"
	Install-Module 'Pester' -MinimumVersion 5.0.0 -Scope CurrentUser -Force
}

# Handle ADO secret variable
if ($MSI.Length -gt 1) {
	Write-Output "Setting up variable IDENTITY_CLIENT_ID with length $($MSI.length)"
	$Env:IDENTITY_CLIENT_ID = $MSI
}

Write-Output "Invoke Pester tests"
Invoke-Pester -Path  'test/Pester/Azmi.Module.Tests.ps1', 'test/Pester/cmdlets/*' -CI 4> $null
# 4> $null redirects verbose output to null, to avoid nosie from certain tests