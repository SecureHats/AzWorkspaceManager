---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Remove-AzWorkspaceManagerAssignment

## SYNOPSIS
Remove Microsoft Sentinel Workspace Manager Assignment

## SYNTAX

```powershell
Remove-AzWorkspaceManagerAssignment [-WorkspaceName] <String> [[-ResourceGroupName] <String>]
 [[-Name] <String>] [[-ResourceId] <Array>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-AzWorkspaceManagerAssignment cmdlet removes a Workspace Manager Assignment from a Microsoft Sentinel Workspace.
The cmdlet will not return an error if the Workspace Manager Assignment does not exist.
The Assignment must first be removed from the Workspace Manager Group before the group can be removed.

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-AzWorkspaceManagerAssignment -WorkspaceName 'myWorkspace' -ResourceGroupName 'ContosoResourceGroup' -Name 'ContosoWorkspaceManagerAssignment'
```

This command removes the Workspace Manager Assignment 'ContosoWorkspaceManagerAssignment' from the workspace 'ContosoWorkspace' in the resource group 'ContosoResourceGroup'.

### EXAMPLE 2
```powershell
Get-AzWorkspaceManagerAssignment -WorkspaceName 'myWorkspace' | Remove-AzWorkspaceManagerAssignment -Force
```

This example removes all Workspace Manager Assignments from the workspace 'ContosoWorkspace' in the resource group 'ContosoResourceGroup' without prompting for confirmation.

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
The Name of the Workspace Manager Assignment

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
