---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Remove-AddAzWorkspaceManagerGroup

## SYNOPSIS
Remove Microsoft Sentinel Workspace Manager

## SYNTAX

```powershell
Remove-AddAzWorkspaceManagerGroup [-WorkspaceName] <String> [[-ResourceGroupName] <String>] [-Name] <String>
 [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This command removes a Workspace Manager Group from a Microsoft Sentinel Workspace.
If the Workspace Manager Group does not exist, the command will return an error.
When the Workspace Manager Group is removed the members of the group will no longer receive updates from the workspace.
If an assigment is still available for the group, the group cannot be removed.

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-AddAzWorkspaceManagerGroup -WorkspaceName 'myWorkspace' -Name 'myChildWorkspace'
```

This example removes the Workspace Manager Group 'myChildWorkspace' from the workspace 'myWorkspace'

### EXAMPLE 2
```powershell
Remove-AddAzWorkspaceManagerGroup -WorkspaceName 'myWorkspace' -ResourceGroupName 'myWorkspaceManagerGroup' -Name 'myChildWorkspace' -Force
```

This example removes the Workspace Manager Group 'myChildWorkspace' from the workspace 'myWorkspace' in the resource group 'myWorkspaceManagerGroup' without prompting for confirmation

### EXAMPLE 3
```powershell
Get-AddAzWorkspaceManagerGroup -WorkspaceName 'myWorkspace' | Remove-AddAzWorkspaceManagerGroup -Force
```

This example removes all Workspace Manager Groups from the workspace 'myWorkspace' without prompting for confirmation using the pipeline

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

### -Name
The Name of the Workspace Manager Group

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

### -Force
Confirms the removal of the Workspace manager configuration.

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
