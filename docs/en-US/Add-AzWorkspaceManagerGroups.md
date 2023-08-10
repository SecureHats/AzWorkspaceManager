---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Add-AzWorkspaceManagerGroups

## SYNOPSIS
Add a Microsoft Sentinel Workspace Manager Group.

## SYNTAX

```
Add-AzWorkspaceManagerGroups [-WorkspaceName] <String> [[-ResourceGroupName] <String>] [-Name] <String>
 [[-Description] <String>] [[-workspaceManagerMembers] <Array>] [[-ResourceId] <Array>] [<CommonParameters>]
```

## DESCRIPTION
The Add-AzWorkspaceManagerGroups cmdlet adds a workspace manager group to the configuration.
It is possible to add child workspaces to the group or add them later.
For adding child
workspaces, use the Add-AzWorkspaceManagerMembers cmdlet.

## EXAMPLES

### EXAMPLE 1
```
Add-AzWorkspaceManagerGroups -WorkspaceName "myWorkspace" -Name "Banks" -workspaceManagerMembers 'myChildWorkspace(***)'
```

This example adds a Workspace Manager Group 'Banks' to the workspace and adds a child workspace to the group.

### EXAMPLE 2
```
Get-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" | Add-AzWorkspaceManagerGroups -Name "Banks"
```

This example adds a Workspace Manager Group 'Banks' to the workspace and adds all child workspaces to the group using the pipeline.

## PARAMETERS

### -WorkspaceName
The Name of the log analytics workspace.

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
The name of the ResouceGroup where the log analytics workspace is located.

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

### -Name
The name of the workspace manager group.

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

### -Description
The description of the workspace manager group.
If not specified, the name will be used.

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

### -workspaceManagerMembers
The workspace manager members to add to the group.
The members are workspaces that are linked to the workspace manager configuration.
and used to provision Microsoft Sentinel workspaces.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceId
{{ Fill ResourceId Description }}

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-AzWorkspaceManagerGroups
Remove-AzWorkspaceManagerGroups
Add-AzWorkspaceManagerMembers
Get-AzWorkspaceManagerMembers]()

