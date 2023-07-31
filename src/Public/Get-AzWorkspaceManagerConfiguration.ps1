function Get-AzWorkspaceManagerConfiguration {
    <#
      .SYNOPSIS
      Get the Azure Sentinel Workspace Manager
      .DESCRIPTION
      This function gets the Workspace Manager and returns the properties if enabled
      .PARAMETER WorkspaceName
      The Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      The name of the ResouceGroup where the log analytics workspace is located
      .EXAMPLE
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName
    )

    begin {
        $MyInvocation.MyCommand.Name | Invoke-AzWorkspaceManager
        if ($ResourceGroupName) {
            Get-LogAnalyticsWorkspace -Name $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            Get-LogAnalyticsWorkspace -Name $WorkspaceName
        }
    }

    process {
        try {
            if ($SessionVariables.workspace) {
                Write-Verbose "Get Microsoft Sentinel Workspace Manager Configuration for workspace [$WorkspaceName)]"
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations?api-version=$($SessionVariables.apiVersion)"

                $requestParam = @{
                    Headers = $authHeader
                    Uri     = $uri
                    Method  = 'GET'
                }
                $apiResponse = (Invoke-RestMethod @requestParam).value
            }
            else {
                Write-Message "Microsoft Sentinel Workspace is not found for workspace [$($WorkspaceName)]" -Severity 'Error'
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
                $SessionVariables.workspaceManagerConfiguration = $apiResponse.properties.mode
                return $result
            }
            else {
                Write-Output "$($MyInvocation.MyCommand.Name): Workspace Manager is not 'configured' for workspace [$($WorkspaceName)]"
                $SessionVariables.workspaceManagerConfiguration = $false
                break
            }
        }
        catch {
            $return = $_.Exception.Message
            Write-Output $return
        }
    }
}