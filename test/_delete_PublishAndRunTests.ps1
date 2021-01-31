./test/PublishModule.ps1

if (!(Get-Module 'Pester' -List | ? Version -ge 5.0.0)) {
	Write-Output "Import Pester 5 module"
	Install-Module 'Pester' -RequiredVersion 5.0.0
}


Write-Output "Run basic test"
Get-Command -Module azmi
