---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Add-AzWorkspaceManagerAssignments

## SYNOPSIS
Adds a Microsoft Sentinel Workspace Manager Group

## SYNTAX

```
Add-AzWorkspaceManagerAssignments [-WorkspaceName] <String> [[-ResourceGroupName] <String>]
 [-GroupName] <String> [[-Name] <Array>] [[-ResourceId] <Array>] [<CommonParameters>]
```

## DESCRIPTION
This function adds a workspace manager group and adds the child workspaces

## EXAMPLES

### EXAMPLE 1
```
Add-AzWorkspaceManagerAssignment -WorkspaceName "myWorkspace" -Name "AlertRules" -GroupName 'myGroup'
```

Adds a Workspace Manager Assignment to the workspace with the name 'AlertRules' and assigns this to the group 'myGroup'.

### EXAMPLE 2
```
Add-AzWorkspaceManagerAssignment -WorkspaceName "myWorkspace" -GroupName 'myGroup'
```

Adds a Workspace Manager Assignment to the workspace with the name 'myGroup(\<GUID\>)' and assigns this to the group 'myGroup'.

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
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
The name of the workspace manager assignment.
if no value is provided a GUID will be generated and added to the name groupname.
'myGroup(afbd324f-6c48-459c-8710-8d1e1cd03812)'

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
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

## RELATED LINKS
