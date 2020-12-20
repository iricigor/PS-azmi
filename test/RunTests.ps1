./test/PublishModule.ps1

if (!(Get-Module 'Pester' -List | ? Version -ge 5.0.0)) {
	Install-Module 'Pester' -RequiredVersion 5.0.0
}

Invoke-Pester -CI