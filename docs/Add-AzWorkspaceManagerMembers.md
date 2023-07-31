---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Add-AzWorkspaceManagerMembers

## SYNOPSIS
Add a Microsoft Sentinel Workspace Manager Member

## SYNTAX

```
Add-AzWorkspaceManagerMembers [-WorkspaceName] <String> [[-ResourceGroupName] <String>]
 [-targetWorkspaceResourceId] <String> [[-targetWorkspaceTenantId] <String>] [<CommonParameters>]
```

## DESCRIPTION
With this function you can add a Microsoft Sentinel Workspace Manager Member

## EXAMPLES

### EXAMPLE 1
```

```

## PARAMETERS

### -WorkspaceName
Enter the Name of the log analytics workspace

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Enter the name of the ResouceGroup where the log analytics workspace is located

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -targetWorkspaceResourceId
The ResourceId of the target workspace to add as a member

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -targetWorkspaceTenantId
The TenantId of the target workspace to add as a member

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
