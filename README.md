# PS-azmi

## Idea
Create PowerShell module which will simplify operations against Azure cloud resources, like storage accounts and key vault.

The following commandlets are planned:
- Common:
  - [x] `Get-AzmiToken`
- Blob
  - [x] `Get-AzmiBlob` - list all blobs
  - [x] `Get-AzmiBlobContent -Blob -File` - downloads single blob
  - [x] `Get-AzmiBlobContent -Container -Directory` - downloads multiple blobs
  - [x] `Set-AzmiBlobContent -Blob -File` - uploads single blob
  - [x] `Set-AzmiBlobContent -Container -Directory` - uploads multiple blobs
- Secret
  - [ ] `Get-AzmiSecret`
  - [ ] `Set-AzmiSecret`
- Certificate
  - [ ] `Get-AzmiCertificate`
  - [ ] `Set-AzmiCertificate`

## Links
Project is based on https://github.com/SRE-PRG/azmitool

## Pipelines

[![Build status](https://dev.azure.com/iiric/PS-azmi/_apis/build/status/PS-azmi-CI)](https://dev.azure.com/iiric/PS-azmi/_build/latest?definitionId=37)

