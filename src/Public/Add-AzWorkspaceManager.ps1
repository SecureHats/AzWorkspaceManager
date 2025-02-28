function Add-AzWorkspaceManager {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage = "It does not match expected pattern '{1}'")]
        [string]$Name,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateSet("Enabled", "Disabled")]
        [string]$Mode = 'Enabled'
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
    }

    process {
        if ($ResourceGroupName) {
            Get-LogAnalyticsWorkspace -Name $Name -ResourceGroupName $ResourceGroupName
        }
        else {
            Get-LogAnalyticsWorkspace -Name $Name
        }

        $payload = @{
            properties = @{
                mode = "$Mode"
            }
        } | ConvertTo-Json -Compress

        try {
            if ($SessionVariables.workspace) {
                Write-Verbose "Configuring Microsoft Sentinel Workspace Manager Configuration for workspace [$Name]"
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/$($Name)?api-version=$($SessionVariables.apiVersion)"

                $requestParam = @{
                    Headers         = $authHeader
                    Uri             = $uri
                    Method          = 'PUT'
                    Body            = $payload
                    ContentType     = 'application/json'
                    UseBasicParsing = $true
                    ErrorVariable   = "ErrVar"
                }

                $apiResponse = Invoke-RestMethod @requestParam
                $result = Format-Result -Message $apiResponse
                return $result
            }
            else {
                Write-Debug "$($MyInvocation.MyCommand.Name): Error configuring Workspace Manager for workspace $($Name)"
            }
        }
        catch {
            Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $ErrVar  -Severity 'Error'
        }
    }
    <#
        .SYNOPSIS
        Creates a Workspace Manager Configuration
        .DESCRIPTION
        The Add-AzWorkspaceManager cmdlet creates a Workspace Manager Configuration that is required to use workspace manager feature.
        You can create a workspace manager configuration by using just a workspacename. The minimum requirement to to enable the
        workspace manager is that Microsoft Sentinel is enabled on the Log Analytics workspace.
        Only one workspace manager configuration can be added per Microsoft Sentinel instance.
        .PARAMETER Name
        Name of the log analytics workspace
        .PARAMETER ResourceGroupName
        Name of the ResouceGroup where the log analytics workspace is located
        .PARAMETER Mode
        Status of the Workspace Manager (Enabled or Disabled)
        .LINK
        Get-AzWorkspaceManager
        Remove-AzWorkspaceManager
        .EXAMPLE
        Add-AzWorkspaceManager -Name 'myWorkspace'

        Name              : myWorkspace
        ResourceGroupName : myRG
        ResourceType      : Microsoft.SecurityInsights/workspaceManagerConfigurations
        WorkspaceName     : myWorkspace
        ResourceId        : /subscriptions/<REDACTED>/resourceGroups/myRG/providers/Microsoft.OperationalInsights/workspaces/myWorkspace/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/myWorkspace
        Tags              :
        Properties        : @{mode=Enabled}

        This command creates / enables the workspace manager on the Sentinel workspace 'myWorkspace'
        .EXAMPLE
        Add-AzWorkspaceManager -Name 'myworkspace' -Mode 'Disabled'

        Name              : myWorkspace
        ResourceGroupName : myRG
        ResourceType      : Microsoft.SecurityInsights/workspaceManagerConfigurations
        WorkspaceName     : myWorkspace
        ResourceId        : /subscriptions/<REDACTED>/resourceGroups/myRG/providers/Microsoft.OperationalInsights/workspaces/myWorkspace/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/myWorkspace
        Tags              :
        Properties        : @{mode=Disabled}

        This command sets the workspace manager to disabled
        .EXAMPLE
        Add-AzWorkspaceManager -Name 'myWorkspace' -ResourceGroupName 'myRG'

        Name              : myWorkspace
        ResourceGroupName : myRG
        ResourceType      : Microsoft.SecurityInsights/workspaceManagerConfigurations
        WorkspaceName     : myWorkspace
        ResourceId        : /subscriptions/<REDACTED>/resourceGroups/myRG/providers/Microsoft.OperationalInsights/workspaces/myWorkspace/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/myWorkspace
        Tags              :
        Properties        : @{mode=Enabled}

        This command enables the workspace manager for the workspace 'myWorkspace' in resource group 'myRg'
        Specifying the resource group is only needed if multiple workspaces with the same name are available in the subscription.
#>
}