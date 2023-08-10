---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Remove-AzWorkspaceManagerAssignmentJobs

## SYNOPSIS
Get the Microsoft Sentinel Workspace Manager Groups

## SYNTAX

```powershell
Remove-AzWorkspaceManagerAssignmentJobs [-WorkspaceName] <String> [[-ResourceGroupName] <String>]
 [[-AssignmentName] <String>] [[-Name] <String>] [[-ResourceId] <Array>] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-AzWorkspaceManagerAssignmentJobs cmdlet removes the Workspace Manager Assignment Jobs from the Workspace Manager Assignment.
When the Workspace Manager Assignment is removed, all the Workspace Manager Assignment Jobs are removed as well.

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-AzWorkspaceManagerAssignmentJobs -WorkspaceName 'myWorkspace' -ResourceGroupName 'myRG' -AssignmentName 'myAssignment' -JobName 'e53fa65b-1e2d-48cd-b079-a596dc6ea5a1'
```

This example removes the Workspace Manager Assignment Job 'e53fa65b-1e2d-48cd-b079-a596dc6ea5a1' from the Workspace Manager Assignment 'myAssignment' in the log analytics workspace 'myWorkspace' in the resource group 'myRG'

### EXAMPLE 2
```powershell
Get-AzWorkspaceManagerAssignmentJobs -WorkspaceName 'myWorkspace' -Name 'MyWorkspaceManagerAssignment' | Remove-AzWorkspaceManagerAssignmentJobs -Force
```

This example removes all the Workspace Manager Assignment Jobs from the Workspace Manager Assignment 'MyWorkspaceManagerAssignment' without prompting for confirmation

### EXAMPLE 3
```powershell
Get-AzWorkspaceManagerAssignments -WorkspaceName 'sentinel-playground' | Get-AzWorkspaceManagerAssignmentJobs | Remove-AzWorkspaceManagerAssignmentJobs -Force
```

This example removes all the Workspace Manager Assignment Jobs from all the Workspace Manager Assignments in the log analytics workspace 'sentinel-playground' without prompting for confirmation

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

### -AssignmentName
The name of the workspace manager assignment (default this has the same value as the Workspace Manager GroupName)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
{{ Fill Name Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ResourceId
{{ Fill ResourceId Description }}

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

### -Force
Confirms the removal of the Workspace manager configuration

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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
