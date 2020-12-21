# PS-azmi

## Idea
Create PowerShell module which will simplify operations against Azure cloud ☁ resources, like storage accounts and key vault.
The biggest difference between these and other Azure commands is that these do not require additional commands for Azure authentication.

Module is targeting PowerShell v.7 and it is compiled with .NET 5.0

## List of Commandlets

The following commandlets are planned:
- 🔑 Common
  - [x] `Get-AzmiToken` - obtains Azure authentication token for use in commands outside of this module
- 💾 Blob
  - [x] `Get-AzmiBlob` - list all blobs
  - [x] `Get-AzmiBlobContent -Blob -File` - downloads single blob
  - [x] `Get-AzmiBlobContent -Container -Directory` - downloads multiple blobs
  - [x] `Set-AzmiBlobContent -Blob -File` - uploads single blob
  - [x] `Set-AzmiBlobContent -Container -Directory` - uploads multiple blobs
- 🔐 Secret
  - [x] `Get-AzmiKeyVaultSecret` - returns a secret from an Azure Key Vault
  - [ ] `Set-AzmiKeyVaultSecret`
- 🧾 Certificate
  - [ ] `Get-AzmiKeyVaultCertificate`
  - [ ] `Set-AzmiKeyVaultCertificate`

All commands support also argument `--Identity` (managed identity client ID), which can be skipped if VM has exactly one managed identity.

## Links
Project is based on a `azmi` Linux CLI project - https://github.com/SRE-PRG/azmitool

## Pipelines

[![Build status](https://dev.azure.com/iiric/PS-azmi/_apis/build/status/PS-azmi-CI)](https://dev.azure.com/iiric/PS-azmi/_build/latest?definitionId=37)
