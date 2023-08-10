---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Get-AzWorkspaceManager

## SYNOPSIS
Gets the Microsoft Sentinel Workspace Manager

## SYNTAX

```
Get-AzWorkspaceManager [-Name] <String> [[-ResourceGroupName] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Get-AzWorkspaceManager cmdlet retrieves a Workspace Manager Configuration from the Log Analytics workspace.
You can retrieve the workspace manager configuration by using just provding a workspacename.
Only one workspace manager configuration can be added per Microsoft Sentinel instance

## EXAMPLES

### EXAMPLE 1
```
Get-AzWorkspaceManager -Name 'myWorkspace'
```

This command gets the workspace manager for the workspace 'myWorkspace'

### EXAMPLE 2
```
Get-AzWorkspaceManager -Name 'myWorkspace' -ResourceGroupName 'myRG'
```

This command gets the workspace manager for the workspace 'myWorkspace' in resource group 'myRg'
Specifying the resource group is only needed if multiple workspaces with the same name are available in the subscription.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Set-AzWorkspaceManager
Remove-AzWorkspaceManager]()

