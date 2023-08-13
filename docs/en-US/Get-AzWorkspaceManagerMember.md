---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Get-AddAzWorkspaceManagerMember

## SYNOPSIS
Gets a Microsoft Sentinel Workspace Manager Member

## SYNTAX

```powershell
Get-AddAzWorkspaceManagerMember [-WorkspaceName] <String> [[-ResourceGroupName] <String>] [[-Name] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-AddAzWorkspaceManagerMember cmdlet gets workspace manager member(s) from the configuration.
If the workspace manager member name is not provided, all the workspace manager members for the workspace will be returned.
When the workspace manager member name is provided, the workspace manager member details will be returned.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AddAzWorkspaceManagerMember -WorkspaceName "myWorkspace"
```

This example gets the Microsoft Sentinel Workspace Manager Members for the workspace 'MyWorkspace'

### EXAMPLE 2
```powershell
Get-AddAzWorkspaceManagerMember -WorkspaceName "myWorkspace" -ResourceGroupName "myResourceGroup"
```

This example gets the Microsoft Sentinel Workspace Manager Members for the workspace 'MyWorkspace' in the resource group 'myResourceGroup'

### EXAMPLE 3
```powershell
Get-AddAzWorkspaceManagerMember -WorkspaceName "myWorkspace" -Name "myChildWorkspace(***)"
```

This example gets the Microsoft Sentinel Workspace Manager Member 'myChildWorkspace(***)' for the workspace 'MyWorkspace'

### EXAMPLE 4
```powershell
Get-AzWorkspaceManager -Name "myWorkspace" | Get-AddAzWorkspaceManagerMember
```

This example gets the Microsoft Sentinel Workspace Manager Members for the workspace 'MyWorkspace' using pipeline

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
Enter the name of the workspace manager member

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
