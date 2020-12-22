$modulePath = './publish/azmi.dll'

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


Write-Output "Invoke Pester tests"
Invoke-Pester 'test/Azmi.Module.Tests.ps1', 'test/cmdlets/*' -Path -CI