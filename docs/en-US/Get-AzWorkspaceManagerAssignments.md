---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Get-AzWorkspaceManagerAssignment

## SYNOPSIS
Get the Microsoft Sentinel Workspace Manager Groups

## SYNTAX

```powershell
Get-AzWorkspaceManagerAssignment [[-WorkspaceName] <String>] [[-ResourceGroupName] <String>]
 [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Get-AzWorkspaceManagerAssignment cmdlet gets the Microsoft Sentinel Workspace Manager Assignments by just specifying the workspace name
When the workspace manager configuration is not 'Enabled' for the workspace, the cmdlet will return an information message
If a Name is specified, the cmdlet will return the details of the workspace manager assignment

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AzWorkspaceManagerAssignment -WorkspaceName 'MyWorkspace'
```

This example gets all the Microsoft Sentinel Workspace Manager Assignments for the workspace 'MyWorkspace'

### EXAMPLE 2
```powershell
Get-AzWorkspaceManagerAssignment -WorkspaceName 'MyWorkspace' -Name 'MyWorkspaceManagerAssignment'
```

This example gets the details of the Microsoft Sentinel Workspace Manager Assignment 'MyWorkspaceManagerAssignment' for the workspace 'MyWorkspace'

## PARAMETERS

### -WorkspaceName
The Name of the log analytics workspace

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
The name of the workspace manager assignment

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS


