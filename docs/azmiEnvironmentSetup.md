# azmi Environment Setup

This page describes in more details how to setup environment in order to be able to use `azmi` commands.
Adapt examples below to your requirements.

Have in mind that this infrastructure setup is enabling you to separate the code and the accesses / secrets.
You do not need to store any access details in your code.
All is configured within infrastructure setup!

## Setup storage account access for a VM

Detailed descriptions can be seen at [MS Docs web page](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/tutorial-vm-windows-access-storage).

Here is just the summary of the actions:
- Create Azure VM and enable system-assigned managed identity
- Create storage account, container and grant VM access
- Login to VM, install azmi module and use it!

## Setup Azure Key Vault (AKV) access for managed Identity (and multiple VMs)

Using user assigned managed identity, you can create shared ID that will be assigned to multiple VMs.
These VMs will than obtain the same access as your managed identity has.

Detailed descriptions can be found at these two MS Docs web pages:
- [Create a user-assigned managed identity](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/how-to-manage-ua-identity-portal#create-a-user-assigned-managed-identity)
- [Assign a user-assigned managed identity](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/qs-configure-portal-windows-vm#user-assigned-managed-identity)
- [Assign a Key Vault access policy](https://docs.microsoft.com/en-us/azure/key-vault/general/assign-access-policy-portal)

Here is the summary of the actions:
- Create managed identity
- Assign managed identity to your VMs
- Assign AKV access policy for managed identity
- Install `azmi` module to VMs and use it!
