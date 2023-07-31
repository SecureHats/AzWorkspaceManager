---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Add-AzWorkspaceManagerGroups

## SYNOPSIS
Get the Azure Sentinel Workspace Manager Groups

## SYNTAX

```
Add-AzWorkspaceManagerGroups [-WorkspaceName] <String> [[-ResourceGroupName] <String>] [-Name] <String>
 [[-Description] <String>] [-workspaceManagerMembers] <Array> [<CommonParameters>]
```

## DESCRIPTION
This function gets the Workspace Manager Groups and properties

## EXAMPLES

### EXAMPLE 1
```

```

## PARAMETERS

### -WorkspaceName
The name of the log analytics workspace

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
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
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the workspace manager group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description of the workspace manager group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -workspaceManagerMembers
The name of the workspace manager member(s) to add to the workspace manager group

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
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
