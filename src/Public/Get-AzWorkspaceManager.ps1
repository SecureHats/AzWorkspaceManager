function Get-AzWorkspaceManager {
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
            Get-LogAnalyticsWorkspace -Name $Name -ResourceGroupName $ResourceGroupName
        } else {
            Get-LogAnalyticsWorkspace -Name $Name
        }
    }

    process {
        #Region Set Constants
        $apiVersion = '2023-06-01-preview'
        #EndRegion Set Constants

        try {
                if ($SessionVariables.workspace) {
                    Write-Verbose "List Azure Sentinel Workspace Manager Configuration for workspace [$Name)]"
                    $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations?api-version=$apiVersion"
            
                    $reponse = (Invoke-RestMethod -Method GET -Uri $uri -Headers $($SessionVariables.authHeader))
                } else {
                    break
                }
                
                return $reponse
        }
        catch {
            $return = $_.Exception.Message
            Write-Output $return
        }
    }
}