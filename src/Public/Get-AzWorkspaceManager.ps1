function Get-AzWorkspaceManager {
    <#
      .SYNOPSIS
      Get the Azure Sentinel Workspace Manager
      .DESCRIPTION
      This function checks if the Workspace Manager is enabled on the Azure Sentinel Workspace Manager
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
            
                    $reponse = (Invoke-RestMethod -Method GET -Uri $uri -Headers $($authHeader))
                } else {
                    break
                }
                
                return $reponse.value
        }
        catch {
            $return = $_.Exception.Message
            Write-Output $return
        }
    }
}