$moduleName = 'azmi'

# install module
Install-Module $moduleName -Repository PSGallery -Scope CurrentUser -Force -MinimumVersion 0.0.2
if (Get-Module $moduleName -List | ? Version -gt 0.0.1) {
    Write-Host "Module installed successfully."
} else {
    Write-Error "Module not installed successfully."
}

# remove module
Uninstall-Module $moduleName -Force
if (Get-Module $moduleName -List -ea 0 | ? Version -gt 0.0.1) {
    Write-Error "Module not uninstalled successfully."
} else {
    Write-Host "Module uninstalled successfully."
}

# install old version
Install-Module $moduleName -Repository PSGallery -Scope CurrentUser -RequiredVersion 0.0.1 -Force
if (Get-Module $moduleName -List | ? Version -eq 0.0.1) {
    Write-Host "Old module installed successfully."
} else {
    Write-Error "Old module not installed successfully."
}

# upgrade module to latest
Update-Module $moduleName -Force
if (Get-Module $moduleName -List | ? Version -gt 0.0.1) {
    Write-Host "Module updated successfully."
} else {
    Write-Error "Module not updated successfully."
}
