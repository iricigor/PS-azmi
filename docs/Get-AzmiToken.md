---
external help file: azmi.dll-Help.xml
Module Name: azmi
online version:
schema: 2.0.0
---

# Get-AzmiToken

## SYNOPSIS
Returns Azure access token for a managed identity

## SYNTAX

```
Get-AzmiToken [[-Identity] <String>] [[-Endpoint] <String>] [-JWTformat] [<CommonParameters>]
```

## DESCRIPTION
This command returns Azure access token for a given managed identity or using a default one. Token can be used for example in commands outside of this module or in OS commands that require communication with Azure resources.

## EXAMPLES

### Example 1
```powershell
PS C:\> $a = Get-AzmiToken
```

Returns Azure authentication token which can be used in other commands. If VM has more than one or has no managed identities, this command will fail.

### Example 2
```powershell
PS C:\> $a = Get-AzmiToken -Identity '117dc05c-4d12-4ac2-b5f8-5e239dc8bc54' -Endpoint 'storage'
```

Returns Azure authentication token for given user assigned identity which can be used for authentication against Azure storage endpoints.

## PARAMETERS

### -Endpoint
Endpoint against which to authenticate. Examples: management, storage. Default 'management'

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: management, storage

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
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JWTformat
Print token in parsed JSON Web Token (JWT) format which contains visible individual token fields.

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

### System.Object
## NOTES

## RELATED LINKS
