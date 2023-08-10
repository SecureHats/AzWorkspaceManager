---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Add-AzWorkspaceManagerAssignmentJobs

## SYNOPSIS
Adds a Microsoft Sentinel Workspace Manager Assignment Job

## SYNTAX

```powershell
Add-AzWorkspaceManagerAssignmentJobs [-WorkspaceName] <String> [[-ResourceGroupName] <String>]
 [[-Name] <String>] [[-ResourceId] <Array>] [<CommonParameters>]
```

## DESCRIPTION
The Add-AzWorkspaceManagerAssignmentJobs command adds a Workspace Manager Assignment Job to the workspace.
By default the name of the Workspace Manager Assignment is the same as the Workspace Manager Group.

## EXAMPLES

### EXAMPLE 1
```powershell
Add-AzWorkspaceManagerAssignmentJobs -WorkspaceName 'MyWorkspace' -Name 'MyWorkspaceManagerAssignment'
```

This example adds a Workspace Manager Assignment Job to the workspace 'MyWorkspace' with the name 'MyWorkspaceManagerAssignment'

### EXAMPLE 2
```powershell
Add-AzWorkspaceManagerAssignmentJobs -WorkspaceName 'MyWorkspace' -ResourceGroupName 'MyResourceGroup'
```

This example adds a Workspace Manager Assignment Job to the workspace 'MyWorkspace' in the resourcegroup 'MyResourceGroup' with the name 'MyWorkspaceManagerAssignment'

### EXAMPLE 3
```powershell
Get-AzWorkspaceManagerAssignments -WorkspaceName 'MyWorkspace' | Add-AzWorkspaceManagerAssignmentJobs
```

This example adds a Workspace Manager Assignment Job to the workspace 'MyWorkspace' for each Workspace Manager Assignment found

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
The name of the workspace manager assignment.
This is the same as the Workspace Manager GroupName unless specified otherwise

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceId
The ResourceId is for support of pipeline values 

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
