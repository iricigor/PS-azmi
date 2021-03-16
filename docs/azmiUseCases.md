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

Anyone can verify download count using following command, but only your script can upload it!

```PowerShell
irm https://azmi.blob.core.windows.net/psazmi/count/16032021
```

And you do not need to setup any complicated authentication methods, passwords, tokens...

## Read secret from Azure Key Vault (AKV)

T.B.D.

## More examples will follow...

![Under Construction](https://openclipart.org/image/400px/231626)