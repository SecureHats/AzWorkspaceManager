function Get-LogAnalyticsWorkspace {
    <#
    .SYNOPSIS
    Get the Log Analytics workspace properties
    .DESCRIPTION
    This function is used to get the Log Analytics workspace properties
    .EXAMPLE
    Get-LogAnalyticsWorkspace
    .NOTES
    NAME: Get-LogAnalyticsWorkspace
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter()]
        [string]$ResourceGroupName
    )

    begin {
        Invoke-AzWorkspaceManager
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
            $apiVersion = '2022-10-01'
        #EndRegion Set Constants

        if ($ResourceGroupName) {
            $uri = "$baseUri/$subscriptionId/resourcegroups/$ResourceGroupName/providers/Microsoft.OperationalInsights/workspaces?api-version=$apiVersion"
        } else {
            $uri = "$baseUri/$subscriptionId/providers/Microsoft.OperationalInsights/workspaces?api-version=$apiVersion"
        }
        
        try {
            Write-Verbose "Trying to get the Log Analytics workspace [$($Name)]"
            $workspace = (
                 Invoke-RestMethod `
                     -Method GET `
                     -Uri $uri `
                     -Headers $script:authHeader).value `
                     | Where-Object { $_.name -eq $Name }
            if ($workspace.count -eq 0) {
                Write-Error -Exception "The Resource '/Microsoft.OperationalInsights/workspaces/$(Name)'"
            }
        } catch {
            Write-Error -Exception "An error occured while trying to get the Log Analytics workspace [$($Name)]"
        }
    }
    end {
        if ($workspace.count -gt 1) {
            Write-Warning -Message "Multiple resource '/Microsoft.OperationalInsights/workspaces/$($Name)' found. Please specify the resourcegroup name"
        } else {
            return $workspace
        }
    }
}