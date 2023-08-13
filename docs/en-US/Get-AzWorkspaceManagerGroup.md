---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Get-AddAzWorkspaceManagerGroup

## SYNOPSIS
Get the Microsoft Sentinel Workspace Manager Groups

## SYNTAX

```powershell
Get-AddAzWorkspaceManagerGroup [-WorkspaceName] <String> [[-ResourceGroupName] <String>] [[-Name] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-AddAzWorkspaceManagerGroup cmdlet gets the Microsoft Sentinel Workspace Manager Groups by just specifying the workspace name
or by specifying the workspace name and the resource group name.
The return value contains the details of the workspace manager groups
including the members.
If no workspace manager groups are found, the cmdlet returns an information message.
If the workspace manager configuration is not enabled, the cmdlet returns an information message.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AddAzWorkspaceManagerGroup -WorkspaceName 'MyWorkspace'
```

This example gets the Microsoft Sentinel Workspace Manager Groups for the workspace 'MyWorkspace'

### EXAMPLE 2
```powershell
Get-AddAzWorkspaceManagerGroup -WorkspaceName 'MyWorkspace' -ResourceGroupName 'MyResourceGroup'
```

This example gets the Microsoft Sentinel Workspace Manager Groups for the workspace 'MyWorkspace' in the resource group 'MyResourceGroup'

### EXAMPLE 3
```powershell
Get-AddAzWorkspaceManagerGroup -WorkspaceName 'MyWorkspace' -Name 'MyWorkspaceManagerGroup'
```

This example gets the Microsoft Sentinel Workspace Manager Group 'MyWorkspaceManagerGroup' for the workspace 'MyWorkspace'

### EXAMPLE 4
```powershell
Get-AzWorkspaceManager -Name 'MyWorkspace' | Get-AddAzWorkspaceManagerGroup
```

This example gets the Microsoft Sentinel Workspace Manager Groups for the workspace 'MyWorkspace' using the pipeline

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
The name of the workspace manager group

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS


