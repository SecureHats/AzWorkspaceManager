---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Set-AzWorkspaceManager

## SYNOPSIS
Set Microsoft Sentinel Workspace Manager

## SYNTAX

```
Set-AzWorkspaceManager [-WorkspaceName] <String> [[-ResourceGroupName] <String>] [[-Mode] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
With this function you can set the Microsoft Sentinel Workspace Manager

## EXAMPLES

### EXAMPLE 1
```
Set-AzWorkspaceManager -Name 'workspaceName' -ResourceGroupName 'resourceGroupName' -Mode 'Enabled'
```

## PARAMETERS

### -WorkspaceName
{{ Fill WorkspaceName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ResourceGroupName
Name of the ResouceGroup where the log analytics workspace is located

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Mode
Status of the Workspace Manager (Enabled or Disabled)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
