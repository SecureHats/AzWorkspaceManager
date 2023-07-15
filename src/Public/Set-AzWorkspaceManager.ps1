function Set-AzWorkspaceManager {
    <#
      .SYNOPSIS
      Enable Azure Sentinel Workspace Manager
      .DESCRIPTION
      With this function you can enable Azure Sentinel Workspace Manager
      .PARAMETER SubscriptionId
      Enter the subscription ID, if no subscription ID is provided then current AZContext subscription will be used
      .PARAMETER Name
      Enter the Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      Enter the name of the ResouceGroup where the log analytics workspace is located
      .EXAMPLE
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string] $SubscriptionId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName
    )

    begin {
        Invoke-AzWorkspaceManager
        $currentWorkspace = Get-LogAnalyticsWorkspace -Name $Name -ResourceGroup $ResourceGroupName
    }

    process {
        switch ($PsCmdlet.ParameterSetName) {
            Sub {
                $arguments = @{
                    WorkspaceName  = $WorkspaceName
                    SubscriptionId = $SubscriptionId
                }
            }
            default {
                $arguments = @{
                    WorkspaceName = $WorkspaceName
                }
            }
        }

        #Region Set Constants
        $baseUri = "https://management.azure.com/subscriptions/"
        $apiVersion = '2023-05-01-preview'
        #EndRegion Set Constants

        try {
            $uri = "$baseUri$($arguments.SubscriptionId)/resourceGroups/$($arguments.ResourceGroupName)/providers/Microsoft.OperationalInsights/workspaces/$($arguments.WorkspaceName)/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations?api-version=$apiVersion"
            $reponse = Invoke-AzRestMethod 
        }
        catch {
            $return = $_.Exception.Message
            Write-Error $return
        }
    }
}

#Region Set Constants
$baseUri = "https://management.azure.com/subscriptions/"
$apiVersion = '2023-05-01-preview'
#EndRegion Set Constants


# "$SubscriptionID/resourceGroups/$ResourceGroupName/providers/Microsoft.OperationalInsights/workspaces/$MasterSentinelName/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations?api-version=$apiVersion""

# $reponse = invoke-azRestMethod -Method GET -Uri 'https://raw.githubusercontent.com/azure/azure-quickstart-templates/master/quickstarts/microsoft.operationalinsights/operational-insights-workspace/azuredeploy.json' -ContentType 'application/json'