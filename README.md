# PS-azmi

## Idea
Create PowerShell module which will simplify operations against Azure cloud ☁ resources, like storage accounts and key vault.
The biggest difference between these and other Azure commands is that these do not require additional commands for Azure authentication.
Authentication is done transparently for the running session using Azure Managed Identity.

Module is written in c# compiled with .NET 5.0. It is targeting PowerShell v.7.

## List of Commandlets

The following commandlets are planned:
- 🔑 Common
  - [x] **`Get-AzmiToken`** - Obtains Azure authentication token for use in commands outside of this module
- 💾 Blob
  - [x] **`Get-AzmiBlob`** - List all blobs from container
  - [x] **`Get-AzmiBlobContent`** - Downloads one or more storage blobs to a local file
  - [x] **`Set-AzmiBlobContent`** - Uploads a local file or directory to an Azure Storage blob or container
- 🔐 Secret
  - [x] **`Get-AzmiKeyVaultSecret`** - Gets the secrets from Azure Key Vault
  - [ ] **`Set-AzmiKeyVaultSecret`** - Creates or updates a secret in a Azure Key Vault
- 🧾 Certificate
  - [ ] **`Get-AzmiKeyVaultCertificate`**
  - [ ] **`Set-AzmiKeyVaultCertificate`**


## Detailed explanation of commands

Here is list of blob commands and their parameters.

### Blob commands 💾

  - [x] `Get-AzmiBlob` - list all blobs
  - [x] `Get-AzmiBlobContent -Blob -File` - downloads single blob
  - [x] `Get-AzmiBlobContent -Container -Directory` - downloads multiple blobs
  - [x] `Set-AzmiBlobContent -Blob -File` - uploads single blob
  - [x] `Set-AzmiBlobContent -Container -Directory` - uploads multiple blobs

All commands support also argument `--Identity` (managed identity client ID), which can be skipped if VM has exactly one managed identity.

## Links

Project is based on a `azmi` Linux CLI project - https://github.com/SRE-PRG/azmitool

## Testing Pipelines

Testing this module presents a challenge, because traditional pipelines do not support managed identity.
Therefore, it is required to have a private pipeline agent on a dedicated ADO pool for module integration testing.

Integration tests -
[![Build Status](https://dev.azure.com/iiric/azmi/_apis/build/status/PS-azmi%20integration%20tests?branchName=master)](https://dev.azure.com/iiric/azmi/_build/latest?definitionId=39&branchName=master)
[![Test detailsBuild Status](https://img.shields.io/azure-devops/tests/iiric/azmi/39)](https://dev.azure.com/iiric/azmi/_build/latest?definitionId=39&branchName=master)

