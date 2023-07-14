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
        [string]$WorkspaceName
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

        $uri = "$baseUri/$subscriptionId/providers/Microsoft.OperationalInsights/workspaces?api-version=$apiVersion" 
        try {
            Write-Verbose "Trying to get the Log Analytics workspace [$($WorkspaceName)]"
            $script:workspace = (
                 Invoke-RestMethod `
                     -Method GET `
                     -Uri $uri `
                     -Headers $authHeader).value `
                     | Where-Object { $_.name -eq $WorkspaceName }
        } catch {
            Write-Output -Message "Log Analytics workspace [$($WorkspaceName)] is not found in the current context"
        }
    }

    end {
        return $script:workspace
    }
}