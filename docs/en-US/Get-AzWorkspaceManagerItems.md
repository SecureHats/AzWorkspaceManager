---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Get-AzWorkspaceManagerItems

## SYNOPSIS
Gets a Microsoft Sentinel Workspace Manager Member

## SYNTAX

```powershell
Get-AzWorkspaceManagerItems [-WorkspaceName] <String> [[-ResourceGroupName] <String>] [[-Name] <String>]
 [[-Type] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Get-AzWorkspaceManagerItems is a helper command to get the resource ids of Microsoft Sentinel resources that can be added to assignments
Currently only three types of resources are supported: AlertRules, AutomationRules and SavedSearches.
When using SavedSearches, the Name parameter
This command currently not supports pipeline input and is still in development.
is ignored due to API limitations.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AzWorkspaceManagerItems -WorkspaceName 'MyWorkspace' -ResourceGroupName 'MyResourceGroup' -Name 'MyAlertRule' -Type 'AlertRules'
```

This example gets the resource id of the AlertRule 'MyAlertRule' in the log analytics workspace 'MyWorkspace' in the resource group 'MyResourceGroup'

### EXAMPLE 2
```powershell
Get-AzWorkspaceManagerItems -WorkspaceName 'MyWorkspace' -ResourceGroupName 'MyResourceGroup' -Type 'AlertRules'
```

This example gets the resource ids of all AlertRules in the log analytics workspace 'MyWorkspace' in the resource group 'MyResourceGroup'

### EXAMPLE 3
```powershell
Get-AzWorkspaceManagerItems -WorkspaceName 'MyWorkspace' -ResourceGroupName 'MyResourceGroup' -Type 'SavedSearches'
```

This example gets the resource ids of all SavedSearches in the log analytics workspace 'MyWorkspace' in the resource group 'MyResourceGroup'

### EXAMPLE 4
```powershell
Get-AzWorkspaceManagerItems -WorkspaceName 'MyWorkspace' -ResourceGroupName 'MyResourceGroup' -Type 'AutomationRules'
```

This example gets the resource ids of all AutomationRules in the log analytics workspace 'MyWorkspace' in the resource group 'MyResourceGroup'

## PARAMETERS

### -WorkspaceName
Enter the Name of the log analytics workspace

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
Enter the name of the ResouceGroup where the log analytics workspace is located

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
Enter the name of the resource to get

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

### -Type
Select the type of resource to get.
Currently only AlertRules, AutomationRules and SavedSearches are supported

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: AlertRules
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This command currently not supports pipeline input and is still in development.

## RELATED LINKS
