$module = 'azmi'

# install and remove
Install-Module $module -Repository PSGallery -Scope CurrentUser -Force
Get-Module $module -List
Uninstall-Module $module -Force
Get-Module $module -List -ea 0

# upgrade
Install-Module $module -Repository PSGallery -Scope CurrentUser -RequiredVersion 0.0.1 -Force
Get-Module $module -List
Update-Module $module -Force
Get-Module $module -List
