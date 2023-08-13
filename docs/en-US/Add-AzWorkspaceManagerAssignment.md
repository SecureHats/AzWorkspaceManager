---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Add-AzWorkspaceManagerAssignment

## SYNOPSIS
Adds a Microsoft Sentinel Workspace Manager Assignment

## SYNTAX

```powershell
Add-AzWorkspaceManagerAssignment [-WorkspaceName] <String> [[-ResourceGroupName] <String>]
 [-GroupName] <String> [[-Name] <Array>] [[-ResourceId] <Array>] [<CommonParameters>]
```

## DESCRIPTION
The Add-AzWorkspaceManagerAssignment command adds a Workspace Manager Assignment to a Workspace Manager Group.
These assignments are used to provision Microsoft Sentinel workspaces.
The Workspace Manager Assignment name is constructed by the GroupName.
The resource id's of the items that are added to the assignment are stored in the properties of the assignment.
These resources need to be in the same instance as the workspace manager configuration.
If the resource id's are not in the same instance as the workspace manager configuration, the assignment will not be created and an error will be thrown.

## EXAMPLES

### EXAMPLE 1
```powershell
Add-AzWorkspaceManagerAssignment -WorkspaceName "myWorkspace" -Name "AlertRules" -GroupName 'myGroup'
```

This example adds a Workspace Manager Assignment to the workspace with the name 'AlertRules' and assigns this to the group 'myGroup'.

### EXAMPLE 2
```powershell
Add-AzWorkspaceManagerAssignment -WorkspaceName "myWorkspace" -Name "AlertRules" -GroupName 'myGroup' -ResourceId "/subscriptions/***/resourceGroups/dev-sentinel/providers/Microsoft.OperationalInsights/workspaces/myWorkspace/providers/Microsoft.SecurityInsights/alertRules/95204744-39a6-4510-8505-ef13549bc0da"
```

This example adds a Workspace Manager Assignment to the workspace with the name 'AlertRules' and assigns this to the group 'myGroup' and adds the alert rule to the assignment.

### EXAMPLE 3
```powershell
Get-AzWorkspaceManagerItems -WorkspaceName "myWorkspace" -Type "AlertRules" | Add-AzWorkspaceManagerAssignment -GroupName 'myGroup'
```

This example gets all the alert rules from the workspace with the name 'myWorkspace' and adds these to the Workspace Manager Assignment with the name 'AlertRules'.

## PARAMETERS

### -WorkspaceName
The name of the log analytics workspace

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

### -GroupName
The name of the workspace manager group

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

### -Name
The name of the workspace manager assignment

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceId
The ResourceId's of the items that to be added to the Workspace Manager Assignment.
This can be a single value or an array of values.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

