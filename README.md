# PS-azmi

## Idea
Create PowerShell module which will simplify operations against Azure cloud resources, like storage accounts and key vault.

The following commandlets are planned:
- Common:
  - `Get-AzmiToken`
- Blob
  - `Get-AzmiBlob`
  - `Get-AzmiBlobs`
  - `Set-AzmiBlob`
  - `Set-AzmiBlobs`
  - `Get-AzmiContainer` _(or `List-AzmiContainer`, bt List is not [approved verb](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands?view=powershell-7.1))_
- Secret
  - `Get-AzmiSecret`
  - `Set-AzmiSecret`
- Certificate
  - `Get-AzmiCertificate`
  - `Set-AzmiCertificate`

## Links
Project is based on https://github.com/SRE-PRG/azmitool

## Pipelines

[![Build status](https://dev.azure.com/iiric/PS-azmi/_apis/build/status/PS-azmi-CI)](https://dev.azure.com/iiric/PS-azmi/_build/latest?definitionId=37)

## Alternate naming idea _(using 2 parameter sets)_
- `Get-AzmiBlob` - list all blobs
- `Get-AzmiBlobContent` -Blob -File
- `Get-AzmiBlobContent` -Container -Directory
- `Set-AzmiBlobContent` -Blob -File
- `Set-AzmiBlobContent` -Container -Directory

