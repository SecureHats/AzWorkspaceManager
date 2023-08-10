---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Get-AzWorkspaceManagerMembers

## SYNOPSIS
Gets a Microsoft Sentinel Workspace Manager Member

## SYNTAX

```
Get-AzWorkspaceManagerMembers [-WorkspaceName] <String> [[-ResourceGroupName] <String>] [[-Name] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-AzWorkspaceManagerMembers cmdlet gets workspace manager member(s) from the configuration.
The members can be queried by providing a workspace name or by providing a workspace manager member name.

## EXAMPLES

### EXAMPLE 1
```
Get-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace"
```

This command gets the workspace manager member(s) from the workspace configuration 'myWorkspace'

### EXAMPLE 2
```
Get-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" -Name "myChildWorkspace(***)"
```

This command gets the workspace manager member myChildWorkspace from the workspace configuration 'myWorkspace'

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
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This command currently not supports pipeline input

## RELATED LINKS
