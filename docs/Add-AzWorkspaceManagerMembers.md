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
Add-AzWorkspaceManagerMembers [-WorkspaceName] <String> [[-ResourceGroupName] <String>] [-ResourceId] <String>
 [-TenantId] <String> [<CommonParameters>]
```

## DESCRIPTION
With this function you can add a Microsoft Sentinel Workspace Manager Member

## EXAMPLES

### EXAMPLE 1
```
Add-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" -ResourceId "/subscriptions/***/resourcegroups/***/providers/microsoft.operationalinsights/workspaces/myWorkspace" -TenantId "***"
```

This example adds a Workspace Manager Member for the workspace with the name 'myWorkspace' and adds the workspace with the name 'myWorkspace' as a member.

Name              : MyChildWorkspace(***)
ResourceGroupName : MyRg
ResourceType      : Microsoft.SecurityInsights/workspaceManagerMembers
ResourceId        : /subscriptions/***/resourceGroups/MyRg/providers/M
                    icrosoft.OperationalInsights/workspaces/muWorkspac
                    e/providers/Microsoft.SecurityInsights/workspaceMa
                    nagerMembers/myChildWorkspace(***)
Tags              : 
Properties        : @{targetWorkspaceResourceId=/subscriptions/***/reso
                    urceGroups/myRg/providers/Microsoft.OperationalInsi
                    ghts/workspaces/myChildWorkspace; targetWorkspaceTe
                    nantId=***}

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
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
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

## RELATED LINKS
