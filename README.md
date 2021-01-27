# PS-azmi

This PowerShell module simplifies operations against Azure cloud ☁ resources, like storage accounts and key vault.
The biggest difference between these and other Azure commands is that these do not require additional commands for Azure authentication.
Authentication is done transparently for the running session using Azure Managed Identity.

Your code can be absolutely free of any secrets, you do not even need to store user names!
Read more about Azure Managed Identities at [MS Docs web site](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview).

This PowerShell module is written in C# compiled with [.NET 5.0](https://docs.microsoft.com/en-us/dotnet/core/dotnet-five). It is targeting [PowerShell version 7](https://docs.microsoft.com/en-us/powershell/scripting/whats-new/what-s-new-in-powershell-70?view=powershell-7.1).

## How to use

In order to use commands from this module you need to setup your environment.
You would need a VM and some target resource that you want to access, like Storage Account or Key Vault.

### Prepare the environment

You can do assign access in two ways:
1) System Assigned Managed Identity

On target resource, just assign access to your VM. More info [here](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/tutorial-linux-vm-access-arm).

2) Using User Assigned Managed Identity

Create new managed identity and assign it to your VM.
On target resource grant appropriate access rights to the identity.

If you want to assign the same access to multiple VMs, this is the preferred method.

### Install the module

Then, inside your Azure VM install this module

```PowerShell
Install-Module PS-azmi
# or
git clone https://github.com/iricigor/PS-azmi
Import-Module PS-azmi/azmi.dll
```

And that is all! Now you can use commands from the module, and authentication will be done transparently
```PowerShell
Get-AzmiToken -JWTFormat
Get-AzmiBlob https://my-storage-account.blob.core.windows.net/my-container
```


## List of Commandlets

The following commandlets are implemented or planned:
- 🔑 Common
  - [x] **`Get-AzmiToken`** - Obtains Azure authentication token for use in commands outside of this module
- 💾 Blob
  - [x] **`Get-AzmiBlob`** - List all blobs from container
  - [x] **`Get-AzmiBlobContent`** - Downloads one or more storage blobs to a local file
  - [x] **`Set-AzmiBlobContent`** - Uploads a local file or directory to an Azure Storage blob or container
- 🔐 Secret
  - [x] **`Get-AzmiSecret`** - Gets the secrets from Azure Key Vault
  - [ ] **`Set-AzmiSecret`** - Creates or updates a secret in a Azure Key Vault
- 🧾 Certificate
  - [ ] **`Get-AzmiCertificate`**
  - [ ] **`Set-AzmiCertificate`**


## Detailed explanation of commands

Here is list of blob commands and their parameters.

All commands support also argument `-Identity` (managed identity client ID), which can be skipped if VM has exactly one managed identity.

All commands support also argument `-Verbose`, which will produce additional output about commandlet execution to verbose output stream.

### Storage Blob commands 💾

  - [x] `Get-AzmiBlob -Container` - List all blobs
  - [x] `Get-AzmiBlobContent -Blob -File -DeleteAfterCopy` - Download single blob
  - [x] `Get-AzmiBlobContent -Container -Directory -DeleteAfterCopy` - Download multiple blobs
  - [x] `Set-AzmiBlobContent -Blob -File` - Upload single blob
  - [x] `Set-AzmiBlobContent -Container -Directory` - Upload multiple blobs

### Key Vault Secret commands 🔐
  - [x] **`Get-AzmiSecret`** - Secret - Get the secrets from Azure Key Vault
  - [ ] **`Set-AzmiSecret`** - Create or update a secret in a Azure Key Vault

## Links

Project is based on a `azmi` Linux CLI project - https://github.com/SRE-PRG/azmitool

Related documentation links:
- How to write a PowerShell cmdlet at [MS Docs web site](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/how-to-write-a-simple-cmdlet?view=powershell-7.1)
- Azure Managed Identities at [MS Docs web site](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview).

## Testing Pipelines

Testing this module presents a challenge, because traditional pipelines do not support managed identity.
Therefore, it is required to have a private pipeline agent on a dedicated ADO pool for module integration testing.

|Test|Results|
|-|-|
| Integration tests | [![Build Status](https://dev.azure.com/iiric/azmi/_apis/build/status/PS-azmi%20integration%20tests?branchName=master)](https://dev.azure.com/iiric/azmi/_build/latest?definitionId=39&branchName=master) [![Test detailsBuild Status](https://img.shields.io/azure-devops/tests/iiric/azmi/39)](https://dev.azure.com/iiric/azmi/_build/latest?definitionId=39&branchName=master)

