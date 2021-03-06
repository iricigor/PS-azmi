---
external help file: azmi.dll-Help.xml
Module Name: azmi
online version:
schema: 2.0.0
---

# Get-AzmiBlobContent

## SYNOPSIS
Download blob from Azure storage account to local file using managed identity.

## SYNTAX

### Single
```
Get-AzmiBlobContent [-Identity <String>] [-DeleteAfterCopy] [-Blob] <String> [[-File] <String>]
 [<CommonParameters>]
```

### Multi
```
Get-AzmiBlobContent [-Identity <String>] [-DeleteAfterCopy] -Container <String> [-Directory <String>]
 [-Exclude <String>] [-Prefix <String>] [<CommonParameters>]
```

## DESCRIPTION
This command downloads one or more blobs from Azure storage account to local file or directory using managed identity.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-AzmiBlobContent -Blob $BlobURL -File ./blob1.txt
```

Downloads blob to local file using default managed identity.

### Example 2
```powershell
PS C:\> Get-AzmiBlobContent -Container $ContainerURL -Directory './data' -DeleteAfterCopy
```

Downloads all blobs from given container to a data folder and deletes successfully downloaded blobs from the container.

## PARAMETERS

### -Blob
URL of blob which will be downloaded.

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
URL of container to which file(s) will be downloaded from. Example https://myaccount.blob.core.windows.net/mycontainer

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

### -DeleteAfterCopy
Switch causing to delete a blob after successful copy. Similar to "move" operations on file system.

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

### -Directory
Path to a local directory to which blobs will be downloaded to. Can be relative or absolute path. Examples: /home/myname/blobs/ or ./mydir

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

### -Exclude
Exclude blobs from downloading that match given regular expression.
It performs client-side filtering.

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
Path to local file to which content will be downloaded to. Can be relative or absolute path. Examples: /tmp/1.txt, ./1.xml.

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

### -Prefix
Specifies a string that filters the results to return only blobs whose name begins with the specified prefix.
It performs server-side filtering.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### None
## NOTES

## RELATED LINKS
