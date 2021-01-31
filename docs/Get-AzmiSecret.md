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
Get-AzmiSecret [-Identity <String>] [-Secret] <String> [<CommonParameters>]
```

## DESCRIPTION
This command gets content of the secret from Azure Key Vault using managed identity.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Identity
{{ Fill Identity Description }}

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
Full secret URL like https://ContosoVault.vault.azure.net/secrets/Password

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

### System.Object
## NOTES

## RELATED LINKS
