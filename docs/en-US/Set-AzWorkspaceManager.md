---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Set-AzWorkspaceManager

## SYNOPSIS
Creates a Workspace Manager Configuration

## SYNTAX

```
Set-AzWorkspaceManager [-Name] <String> [[-ResourceGroupName] <String>] [[-Mode] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Set-AzWorkspaceManager cmdlet creates a Workspace Manager Configuration that is required to use workspace manager feature.
You can create a workspace manager configuration by using just a workspacename.
The minimum requirement to to enable the
workspace manager is that Microsoft Sentinel is enabled on the Log Analytics workspace.
Only one workspace manager configuration can be added per Microsoft Sentinel instance.

## EXAMPLES

### EXAMPLE 1
```
Set-AzWorkspaceManager -Name 'myWorkspace'
```

Name              : myWorkspace
ResourceGroupName : myRG
ResourceType      : Microsoft.SecurityInsights/workspaceManagerConfigurations
WorkspaceName     : myWorkspace
ResourceId        : /subscriptions/\<REDACTED\>/resourceGroups/myRG/providers/Microsoft.OperationalInsights/workspaces/myWorkspace/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/myWorkspace
Tags              :
Properties        : @{mode=Enabled}

This command creates / enables the workspace manager on the Sentinel workspace 'myWorkspace'

### EXAMPLE 2
```
Set-AzWorkspaceManager -Name 'myworkspace' -Mode 'Disabled'
```

Name              : myWorkspace
ResourceGroupName : myRG
ResourceType      : Microsoft.SecurityInsights/workspaceManagerConfigurations
WorkspaceName     : myWorkspace
ResourceId        : /subscriptions/\<REDACTED\>/resourceGroups/myRG/providers/Microsoft.OperationalInsights/workspaces/myWorkspace/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/myWorkspace
Tags              :
Properties        : @{mode=Disabled}

This command sets the workspace manager to disabled

### EXAMPLE 3
```
Set-AzWorkspaceManager -Name 'myWorkspace' -ResourceGroupName 'myRG'
```

Name              : myWorkspace
ResourceGroupName : myRG
ResourceType      : Microsoft.SecurityInsights/workspaceManagerConfigurations
WorkspaceName     : myWorkspace
ResourceId        : /subscriptions/\<REDACTED\>/resourceGroups/myRG/providers/Microsoft.OperationalInsights/workspaces/myWorkspace/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/myWorkspace
Tags              :
Properties        : @{mode=Enabled}

This command enables the workspace manager for the workspace 'myWorkspace' in resource group 'myRg'
Specifying the resource group is only needed if multiple workspaces with the same name are available in the subscription.

## PARAMETERS

### -Name
Name of the log analytics workspace

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
Name of the ResouceGroup where the log analytics workspace is located

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

### -Mode
Status of the Workspace Manager (Enabled or Disabled)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Enabled
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-AzWorkspaceManager
Remove-AzWorkspaceManager]()

