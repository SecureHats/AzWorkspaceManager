function Enable-AzSentinelAlertRule {
    <#
      .SYNOPSIS
      Enable Azure Sentinel Alert Rules
      .DESCRIPTION
      With this function you can enable Azure Sentinel Alert rule
      .PARAMETER SubscriptionId
      Enter the subscription ID, if no subscription ID is provided then current AZContext subscription will be used
      .PARAMETER WorkspaceName
      Enter the Workspace name
      .PARAMETER RuleName
      Enter the name of the Alert rule
      .EXAMPLE
      Enable-AzSentinelAlertRule -WorkspaceName "" -RuleName "",""
      In this example you can get configuration of multiple alert rules in once
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string] $SubscriptionId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceName
    )

    begin {
        Invoke-AzWorkspaceManager
        $workspace = Get-LogAnalyticsWorkspace -WorkspaceName $WorkspaceName //TODO: return values and build query
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