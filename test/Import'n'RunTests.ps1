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
	Write-Output "Import Pester 5 module"
	Install-Module 'Pester' -RequiredVersion 5.0.0
}


Write-Output "Invoke Pester tests"
Invoke-Pester -CI