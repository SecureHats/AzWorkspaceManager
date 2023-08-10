---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Remove-AzWorkspaceManager

## SYNOPSIS
Remove Microsoft Sentinel Workspace Manager

## SYNTAX

```
Remove-AzWorkspaceManager [-Name] <String> [[-ResourceGroupName] <String>] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-AzWorkspaceManager cmdlet retrieves a Workspace Manager Configuration and removes
it from the Log Analytics workspace.
You can remove the workspace manager configuration by
just providing a workspacename.

## EXAMPLES

### EXAMPLE 1
```
Remove-AzWorkspaceManager -Name 'myWorkspace' -Force
```

This command removes the workspace manager on the Sentinel workspace 'myWorkspace'

### EXAMPLE 2
```
Remove-AzWorkspaceManager -Name sentinel-playground -Force
```

This command removes the workspace manager on the Sentinel workspace 'myWorkspace' without confirmation'

### EXAMPLE 3
```
Get-AzWorkspaceManager -Name sentinel-playground | Remove-AzWorkspaceManager -Force
```

This command removes the workspace manager based on a pipeline value from the Get-AzWorkspaceManager cmdlet

## PARAMETERS

### -Name
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

[Get-AzWorkspaceManager
Set-AzWorkspaceManager]()

