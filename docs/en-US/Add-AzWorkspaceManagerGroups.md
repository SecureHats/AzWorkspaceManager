---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Add-AzWorkspaceManagerGroups

## SYNOPSIS
Adds a Microsoft Sentinel Workspace Manager Group

## SYNTAX

```
Add-AzWorkspaceManagerGroups [-WorkspaceName] <String> [[-ResourceGroupName] <String>] [-Name] <String>
 [[-Description] <String>] [[-workspaceManagerMembers] <Array>] [<CommonParameters>]
```

## DESCRIPTION
This function adds a workspace manager group and adds the child workspaces

## EXAMPLES

### EXAMPLE 1
```
Add-AzWorkspaceManagerGroups -WorkspaceName "myWorkspace" -Name "Banks" -Description "" -workspaceManagerMembers 'myWorkspace(afbd324f-6c48-459c-8710-8d1e1cd03812)'
Adds a Workspace Manager Group to the workspace with the name 'Banks' and adds a child workspace with the name 'myWorkspace(afbd324f-6c48-459c-8710-8d1e1cd03812)' to the group.
```

### EXAMPLE 2
```
Add-AzWorkspaceManagerGroups -WorkspaceName "myWorkspace" -ResourceGroupName 'MyRg' -Name "Banks" -Description "Group of all financial and banking institutions" -workspaceManagerMembers @('myWorkspace(afbd324f-6c48-459c-8710-8d1e1cd03812)', 'otherWorkspace(f5fa104e-c0e3-4747-9182-d342dc048a9e)')
Adds a Workspace Manager Group to the workspace and adds multiple child workspaces to the group.
```

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

### -Name
The name of the workspace manager group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
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
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -workspaceManagerMembers
The name of the workspace manager member(s) to add to the workspace manager group

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
