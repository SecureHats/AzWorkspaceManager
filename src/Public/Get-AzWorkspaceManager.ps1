function Get-AzWorkspaceManager {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage = "It does not match expected pattern '{1}'")]
        [string]$Name,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName
    )

    begin {
        $MyInvocation.MyCommand.Name | Invoke-AzWorkspaceManager
    }

    process {
        if ($ResourceGroupName) {
            Get-LogAnalyticsWorkspace -Name $Name -ResourceGroupName $ResourceGroupName
        }
        else {
            Get-LogAnalyticsWorkspace -Name $Name
        }

        try {
            if ($SessionVariables.workspace) {
                Write-Verbose "Get Microsoft Sentinel Workspace Manager Configuration for workspace '$Name'"
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations?api-version=$($SessionVariables.apiVersion)"

                $requestParam = @{
                    Headers = $authHeader
                    Uri     = $uri
                    Method  = 'GET'
                }
                $apiResponse = (Invoke-RestMethod @requestParam).value
            }
            else {
                Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "Microsoft Sentinel was not found under workspace '$Name'" -Severity 'Error'
            }

            if ($apiResponse -ne '') {
                $SessionVariables.workspaceManagerConfiguration = $apiResponse.properties.mode
                $result = Format-Result -Message $apiResponse
                return $result
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "Workspace Manager is not configured for workspace '$Name'" -Severity 'Information'
                $SessionVariables.workspaceManagerConfiguration = $false
            }
        }
        catch {
            Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $($_.Exception.Message) -Severity 'Error'
        }
    }
<#
    .SYNOPSIS
    Gets the Microsoft Sentinel Workspace Manager
    .DESCRIPTION
    The Get-AzWorkspaceManager cmdlet retrieves a Workspace Manager Configuration from the Log Analytics workspace.
    You can retrieve the workspace manager configuration by using just provding a workspacename.
    Only one workspace manager configuration can be added per Microsoft Sentinel instance
    .PARAMETER Name
    The Name of the log analytics workspace
    .PARAMETER ResourceGroupName
    The name of the ResouceGroup where the log analytics workspace is located
    .LINK
    Set-AzWorkspaceManager
    Remove-AzWorkspaceManager
    .EXAMPLE
    Get-AzWorkspaceManager -Name 'myWorkspace'

    Name              : myWorkspace
    ResourceGroupName : myRG
    ResourceType      : Microsoft.SecurityInsights/workspaceManagerConfigurations
    WorkspaceName     : myWorkspace
    ResourceId        : /subscriptions/<REDACTED>/resourceGroups/myRG/providers/Microsoft.OperationalInsights/workspaces/myWorkspace/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/myWorkspace
    Tags              :
    Properties        : @{mode=Enabled}
    This command gets the workspace manager for the workspace 'myWorkspace'
    .EXAMPLE
    Get-AzWorkspaceManager -Name 'myWorkspace' -ResourceGroupName 'myRG'

    Name              : myWorkspace
    ResourceGroupName : myRG
    ResourceType      : Microsoft.SecurityInsights/workspaceManagerConfigurations
    WorkspaceName     : myWorkspace
    ResourceId        : /subscriptions/<REDACTED>/resourceGroups/myRG/providers/Microsoft.OperationalInsights/workspaces/myWorkspace/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/myWorkspace
    Tags              :
    Properties        : @{mode=Enabled}

    This command gets the workspace manager for the workspace 'myWorkspace' in resource group 'myRg'
    Specifying the resource group is only needed if multiple workspaces with the same name are available in the subscription.
#>
}