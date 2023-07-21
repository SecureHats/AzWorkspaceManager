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
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
        if ($ResourceGroupName) {
            $currentWorkspace = Get-LogAnalyticsWorkspace -Name $Name -ResourceGroupName $ResourceGroupName
        } else {
            $currentWorkspace = Get-LogAnalyticsWorkspace -Name $Name
        }
    }

    process {
        #Region Set Constants
        $apiVersion = '2023-05-01-preview'
        #EndRegion Set Constants

        # try {
            if ($ResourceGroupName) {
                Write-Verbose "Resource Group Name: $ResourceGroupName"
                # $uri = "$baseUri$($Script:SubscriptionId)/resourceGroups/$ResourceGroupName/providers/Microsoft.OperationalInsights/workspaces/$Name/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/demo01?api-version=$apiVersion"
                $uri = "$baseUri$($Script:SubscriptionId)/resourceGroups/$ResourceGroupName/providers/Microsoft.OperationalInsights/workspaces/$Name/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations?api-version=2023-05-01-preview"
            } else {
                Write-Verbose "No Resource Group Name specified"
                $uri = "$baseUri$($Script:SubscriptionId)/providers/Microsoft.OperationalInsights/workspaces/$Name)/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/demo01?api-version=$apiVersion"
            }
            Write-Verbose "Trying to enable Azure Sentinel Workspace Manager for workspace [$Name)]"
            Write-Output "URI: $uri"
            Invoke-RestMethod `
                     -Method GET `
                     -Uri $uri `
                     -Headers $script:authHeader
        # }
        # catch {
        #     $return = $_.Exception.Message
        #     Write-Output $uri  #$return
        # }
    }
}


# "$SubscriptionID/resourceGroups/$ResourceGroupName/providers/Microsoft.OperationalInsights/workspaces/$MasterSentinelName/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations?api-version=$apiVersion""

# $reponse = invoke-azRestMethod -Method GET -Uri 'https://raw.githubusercontent.com/azure/azure-quickstart-templates/master/quickstarts/microsoft.operationalinsights/operational-insights-workspace/azuredeploy.json' -ContentType 'application/json'