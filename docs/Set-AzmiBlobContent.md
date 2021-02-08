---
external help file: azmi.dll-Help.xml
Module Name: azmi
online version:
schema: 2.0.0
---

# Set-AzmiBlobContent

## SYNOPSIS
Uploads local file to Azure storage blob using managed identity

## SYNTAX

### Single
```
Set-AzmiBlobContent [-Identity <String>] [-Force] [-Blob] <String> [[-File] <String>] [<CommonParameters>]
```

### Multi
```
Set-AzmiBlobContent [-Identity <String>] [-Force] -Container <String> [-Directory <String>]
 [<CommonParameters>]
```

## DESCRIPTION
This command uploads local file or directory to Azure storage blob or container using managed identity.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-AzmiBlobContent -Blob $BlobURL -File ./myFile.txt
```

Uploads local file to the Azure Storage Blob using default managed identity.

## PARAMETERS

### -Blob
URL of blob which will be updated.

```yaml
Type: String
Parameter Sets: Single
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Container
URL of container to which file(s) will be uploaded to. Example https://myaccount.blob.core.windows.net/mycontainer

```yaml
Type: String
Parameter Sets: Multi
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Directory
Path to a local directory from which blobs will be uploaded from. Can be relative or absolute path. Examples: /home/myname/blobs/ or ./mydir

```yaml
Type: String
Parameter Sets: Multi
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -File
Path to local file to which will be uploaded to a blob. Can be relative or absolute path. Examples: /tmp/1.txt, ./1.xml.

```yaml
Type: String
Parameter Sets: Single
Aliases:

Required: False
Position: 1
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

### -Force
If specified, it forces cmdlet to overwrite existing blob(s) in Azure.
By default, cmdlet will fail if target blob exists.

```yaml
Type: SwitchParameter
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

### None
## NOTES

## RELATED LINKS
