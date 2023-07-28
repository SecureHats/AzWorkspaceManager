function Remove-AzWorkspaceManager {
    <#
      .SYNOPSIS
      Remove Azure Sentinel Workspace Manager
      .DESCRIPTION
      With this function you can enable Azure Sentinel Workspace Manager
      .PARAMETER Name
      Enter the Name of the log analytics workspace
      .PARAMETER WorkspaceConfigurationName
      The name of the workspace configuration when different than the workspace name.
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
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [string]$WorkspaceConfigurationName
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
        if ($ResourceGroupName) {
            $null = Get-LogAnalyticsWorkspace -Name $Name -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-LogAnalyticsWorkspace -Name $Name
        }
    }

    process {
        $apiVersion = '2023-06-01-preview'
        
        try {
            if ($SessionVariables.workspace) {
                Write-Verbose "Performing the operation 'Removing workspace manager ...' on target '$Name'"
                if ($WorkspaceConfigurationName) { $Name = $WorkspaceConfigurationName }
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/$($Name)?api-version=$apiVersion"
                
                $requestParam = @{
                    Headers = $authHeader
                    Uri     = $uri
                    Method  = 'DELETE'
                }
                
                $reponse = Invoke-RestMethod @requestParam
                return $reponse
            }
            else {
                Write-Host "$($MyInvocation.MyCommand.Name): No valid Workspace Manager configuration found"
            }
        }
        catch {
            $reponse = $_.Exception.Message
            Write-Output $reponse
        }
    }
}