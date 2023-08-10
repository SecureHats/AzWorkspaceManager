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
Add-AzWorkspaceManagerMembers [-WorkspaceName] <String> [[-ResourceGroupName] <String>] [-ResourceId] <Array>
 [-TenantId] <String> [<CommonParameters>]
```

## DESCRIPTION
The Add-AzWorkspaceManagerMembers cmdlet adds a workspace manager member to the configuration.
These members are workspaces that are linked to the workspace manager configuration.
and used to
provision Microsoft Sentinel workspaces.
The Workspace Manager Member name is constructed as follows: \<workspaceName\>(\<subscriptionId\>)

## EXAMPLES

### EXAMPLE 1
```
Add-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" -ResourceId "/subscriptions/***/resourcegroups/myRemoteRG/providers/microsoft.operationalinsights/workspaces/myChildWorkspace" -TenantId "***"
```

This example adds a Workspace Manager Member for the workspace with the name 'myWorkspace' and adds the workspace with the name 'myChildWorkspace' as a member.

### EXAMPLE 2
```
$resourceIds = @("/subscriptions/***/resourcegroups/myRemoteRG/providers/microsoft.operationalinsights/workspaces/myChildWorkspace", "/subscriptions/***/resourcegroups/myRemoteRG/providers/microsoft.operationalinsights/workspaces/myOtherWorkspace")
```

PS \> Add-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" -ResourceId $resourceIds -TenantId "***"

This example adds a multiple Members from from an array into the workspace manager with the name 'myWorkspace'

## PARAMETERS

### -WorkspaceName
The Name of the log analytics workspace

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
The name of the ResouceGroup where the log analytics workspace is located

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

### -ResourceId
The ResourceId of the target workspace to add as a member

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TenantId
The TenantId of the target workspace to add as a member

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The Workspace Manager Member name is constructed as follows: \<workspaceName\>(\<subscriptionId\>)

