---
external help file: AzWorkspaceManager-help.xml
Module Name: AzWorkspaceManager
online version:
schema: 2.0.0
---

# Get-AzWorkspaceManagerAssignmentJobs

## SYNOPSIS
Get the Microsoft Sentinel Workspace Manager Groups

## SYNTAX

```
Get-AzWorkspaceManagerAssignmentJobs [-WorkspaceName] <String> [[-ResourceGroupName] <String>]
 [[-Name] <String>] [[-JobName] <String>] [[-ResourceId] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function gets the Workspace Manager Groups and properties

## EXAMPLES

### EXAMPLE 1
```

```

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
The name of the workspace manager assignment (default this has the same value as the Workspace Manager GroupName)

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

### -JobName
The name of the Workspace Manager Assignment Job

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ResourceId
{{ Fill ResourceId Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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