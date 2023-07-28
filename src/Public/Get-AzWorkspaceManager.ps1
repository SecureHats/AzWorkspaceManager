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
    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$WorskpaceConfigurationName
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
        if ($ResourceGroupName) {
            Get-LogAnalyticsWorkspace -Name $Name -ResourceGroupName $ResourceGroupName
        }
        else {
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
                Write-Verbose $uri
                $requestParam = @{
                    Headers = $authHeader
                    Uri     = $uri
                    Method  = 'GET'
                }
                $apiResponse = (Invoke-RestMethod @requestParam).value
            }
            else {
                break
            }
            
            if ($apiResponse -ne '') {
                $split = $apiResponse.id.Split('/')
                $result = [ordered]@{
                    Name              = $split[-1]
                    ResourceGroupName = $split[-9]
                    ResourceType      = '{0}/{1}' -f $split[-3], $split[-2]
                    Location          = $apiResponse.location
                    ResourceId        = $apiResponse.id
                    Tags              = $apiResponse.tags
                    Properties        = $apiResponse.properties
                } | ConvertTo-Json | ConvertFrom-Json
                return $result
            }
            else {
                Write-Output "$($MyInvocation.MyCommand.Name): Workspace Manager is not 'configured' for workspace [$($Name)]"
            }
        }
        catch {
            $return = $_.Exception.Message
            Write-Output $return
        }
    }
}