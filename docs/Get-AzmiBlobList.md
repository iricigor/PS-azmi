---
external help file: azmi.dll-Help.xml
Module Name: azmi
online version:
schema: 2.0.0
---

# Get-AzmiBlobList

## SYNOPSIS
Lists blobs from Azure storage account container using managed identity

## SYNTAX

```
Get-AzmiBlobList [-Identity <String>] [-Container] <String> [<CommonParameters>]
```

## DESCRIPTION
This command lists blobs from Azure storage account container using managed identity.

## EXAMPLES

### Example 1
```powershell
PS C:\> (Get-AzmiBlobList $ContainerURL).Count
```

Use default managed identity to obtain list of blobs from given Azure Storage Container and returns their count.

## PARAMETERS

### -Container
URL of container whose blobs will be listed. Example https://myaccount.blob.core.windows.net/mycontainer

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.String
## NOTES

## RELATED LINKS
