---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Remove-AzWorkspaceManagerMembers

## SYNOPSIS
Remove a Workspace Manager Member

## SYNTAX

```
Remove-AzWorkspaceManagerMembers [-WorkspaceName] <String> [[-ResourceGroupName] <String>] [[-Name] <String>]
 [[-ResourceId] <Array>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-AzWorkspaceManagerMembers cmdlet removes a workspace manager member to the configuration.

## EXAMPLES

### EXAMPLE 1
```
Remove-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" -Name "myChildWorkspace(***)"
```

This command removes the workspace manager member myChildWorkspace from the workspace configuration 'myWorkspace'

### EXAMPLE 2
```
Remove-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" -ResourceGroup "myRG" -Name "myChildWorkspace(***)" -Force
```

This command removes the workspace manager member myChildWorkspace from the workspace configuration 'myWorkspace' without confirmation

### EXAMPLE 3
```
Get-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" | Remove-AzWorkspaceManagerMembers -Force
```

This command removes all workspace manager members from the workspace configuration 'myWorkspace' without confirmation

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
The Name of the Workspace Manager Member

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

### -ResourceId
The ResourceId of the target workspace manager member to remove

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
