function Get-AzWorkspaceManagerGroup {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters.ResourceNameCompleterAttribute(
            "Microsoft.OperationalInsights/workspaces",
            "ResourceGroupName"
        )][string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters.ResourceGroupCompleterAttribute()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
    }

    process {
        if ($ResourceGroupName) {
            $null = Get-AzWorkspaceManager -Name $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManager -Name $WorkspaceName
        }

        if ($null -ne $Name) {
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerGroups/$($Name)?api-version=$($SessionVariables.apiVersion)"
        }
        else {
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerGroups?api-version=$($SessionVariables.apiVersion)"
        }

        if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
            try {
                Write-Verbose "List Microsoft Sentinel Workspace Manager Groups for workspace [$WorkspaceName)]"

                $requestParam = @{
                    Headers       = $authHeader
                    Uri           = $uri
                    Method        = 'GET'
                    ErrorVariable = 'ErrVar'
                }
                if ($Name) {
                    $apiResponse = (Invoke-RestMethod @requestParam)
                }
                else {
                    $apiResponse = (Invoke-RestMethod @requestParam).value
                }

                if ($apiResponse -ne '') {
                    foreach ($object in $apiResponse) {
                        $result = Format-Result -Message $apiResponse
                    }

                    return $result
                }
                else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "No Workspace Manager Group(s) found for workspace '$WorkspaceName'" -Severity 'Information'
                }
            }
            catch {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message ($return.ErrorRecord | ConvertFrom-Json).error.message -Severity 'Error'
            }
        }
        else {
            Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "The Workspace Manager configuration is not 'Enabled' for workspace '$WorkspaceName'" -Severity 'Information'
        }
    }
    <#
        .SYNOPSIS
        Get the Microsoft Sentinel Workspace Manager Groups
        .DESCRIPTION
        The Get-AzWorkspaceManagerGroup cmdlet gets the Microsoft Sentinel Workspace Manager Groups by just specifying the workspace name
        or by specifying the workspace name and the resource group name. The return value contains the details of the workspace manager groups
        including the members. If no workspace manager groups are found, the cmdlet returns an information message.
        If the workspace manager configuration is not enabled, the cmdlet returns an information message.
        .PARAMETER WorkspaceName
        The Name of the log analytics workspace
        .PARAMETER ResourceGroupName
        The name of the ResouceGroup where the log analytics workspace is located
        .PARAMETER Name
        The name of the workspace manager group
        .EXAMPLE
        Get-AzWorkspaceManagerGroup -WorkspaceName 'MyWorkspace'

        This example gets the Microsoft Sentinel Workspace Manager Groups for the workspace 'MyWorkspace'
        .EXAMPLE
        Get-AzWorkspaceManagerGroup -WorkspaceName 'MyWorkspace' -ResourceGroupName 'MyResourceGroup'

        This example gets the Microsoft Sentinel Workspace Manager Groups for the workspace 'MyWorkspace' in the resource group 'MyResourceGroup'
        .EXAMPLE
        Get-AzWorkspaceManagerGroup -WorkspaceName 'MyWorkspace' -Name 'MyWorkspaceManagerGroup'

        This example gets the Microsoft Sentinel Workspace Manager Group 'MyWorkspaceManagerGroup' for the workspace 'MyWorkspace'
        .EXAMPLE
        Get-AzWorkspaceManager -Name 'MyWorkspace' | Get-AzWorkspaceManagerGroup

        This example gets the Microsoft Sentinel Workspace Manager Groups for the workspace 'MyWorkspace' using the pipeline
        .LINK
        Add-AzWorkspaceManagerGroup
        Remove-AzWorkspaceManagerGroup
        Get-AzWorkspaceManager
    #>
}