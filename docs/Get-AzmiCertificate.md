---
external help file: azmi.dll-Help.xml
Module Name: azmi
online version:
schema: 2.0.0
---

# Get-AzmiCertificate

## SYNOPSIS
Get certificate content from Azure Key Vault using managed identity

## SYNTAX

```
Get-AzmiCertificate [-Identity <String>] [-Certificate] <String> [-File <String>] [<CommonParameters>]
```

## DESCRIPTION
This command gets certificate content from Azure Key Vault using managed identity.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-AzmiCertificate "$KVURL/certificates/MyCert"
```

Obtains 'MyCert' certificate from Azure Key Vault using default managed identity.
Please note that returned value is sensitive information and it should be treated as such.

### Example 2
```powershell
PS C:\> Get-AzmiCertificate "$KVURL/certificates/MyCert/103a7355c6095bc78307b2db7b85b3c2"
```

Obtains specific version of 'MyCert' certificate from Azure Key Vault.

## PARAMETERS

### -Certificate
Full URL of certificate like https://ContosoVault.vault.azure.net/certificates/MyCert

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.String
## NOTES

## RELATED LINKS
