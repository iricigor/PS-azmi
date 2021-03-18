---
external help file: azmi.dll-Help.xml
Module Name: azmi
online version:
schema: 2.0.0
---

# Get-AzmiSecret

## SYNOPSIS
Get content of the secret from Azure Key Vault using managed identity

## SYNTAX

```
Get-AzmiSecret [-Identity <String>] [-Secret] <String> [-File <String>] [<CommonParameters>]
```

## DESCRIPTION
This command gets content of the secret from Azure Key Vault using managed identity.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-AzmiSecret "$KVURL/secrets/ReadPassword/6f7c24526c4d489594ca27a85edf6176"
```

Obtains specific version of 'ReadPassword' secret from Azure Key Vault using default managed identity.
Please note that returned value is sensitive information and it should be treated as such.

## PARAMETERS

### -File
Path to local file to which content will be downloaded.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Identity
Client or application ID of managed identity used to authenticate. Example: 117dc05c-4d12-4ac2-b5f8-5e239dc8bc54

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Secret
Full URL of Key Vault secret like https://ContosoVault.vault.azure.net/secrets/Password. It can optionally include also version info at the end, like 6f7c24426c4d489594ca27a85edf6176.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.String
## NOTES

## RELATED LINKS
