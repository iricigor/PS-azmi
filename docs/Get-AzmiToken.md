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
This command returns Azure access token for a given managed identity or using a default one.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Endpoint
{{ Fill Endpoint Description }}

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
{{ Fill Identity Description }}

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
{{ Fill JWTformat Description }}

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
