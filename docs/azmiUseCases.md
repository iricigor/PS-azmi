# azmi use cases

Here is a list of examples of potential use cases for azmi module.
If you have any additional suggestions, feel free to open an issue or pull request.

## Save download count to public storage account

Setup new Azure storage account and make public container, readable by anyone.
Setup write access to that container for your VM.
Execute code similar to the following one or schedule it to run daily.

```PowerShell
$container = 'https://azmi.blob.core.windows.net/psazmi'

$date = Get-Date -Format 'ddMMyyyy'
$blob = $container + '/count/' + $date

$module = Find-Module azmi
$downloadCount = $module.AdditionalMetadata.downloadCount

$tempFile = New-TemporaryFile
Set-Content -Path $tempFile -Value $downloadCount

# azmi upload to blob
Set-AzmiBlobContent -Blob $blob -File $tempFile

Remove-Item $tempFile
```

Anyone can verify download count using following command, due to public read access.
But only your script can upload it due protected azmi access - and yet code is completely public!

```PowerShell
irm https://azmi.blob.core.windows.net/psazmi/count/16032021
```

And you do not need to setup any complicated authentication methods, passwords, tokens...

## Read secret from Azure Key Vault (AKV) and upload PS module to Gallery

Small sample below demonstrates how to upload you PowerShell module to PS Gallery.
If you want, you can easily convert it to one-liner 😉

```PowerShell
$Key = Get-azmiSecret 'https://ContosoVault.vault.azure.net/secrets/UploadModuleKey'
Publish-Module -Path . -Repository PSGallery -NuGetApiKey $Key -ea Stop -Verbose
```

Previously, you would need to register your account on PS Gallery and create upload key.
Next you would store a key in Key Vault and grant access to your VM for that AKV.
And, then you can use code above on the VM to upload module without hassle.

## More examples will follow...
