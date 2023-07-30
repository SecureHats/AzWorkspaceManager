function Remove-AzWorkspaceManagerConfiguration {
    <#
      .SYNOPSIS
      Remove Azure Sentinel Workspace Manager
      .DESCRIPTION
      This function removes the Azure Sentinel Workspace Manager configuration
      .PARAMETER Name
      The Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      The name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER WorkspaceConfigurationName
      The name of the workspace configuration when different than the workspace name.
      .PARAMETER Force
      Confirms the removal of the Workspace manager configuration.
      .EXAMPLE
    #>
    [cmdletbinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [string]$WorkspaceConfigurationName,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
        if ($ResourceGroupName) {
            $null = Get-LogAnalyticsWorkspace -Name $Name -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-LogAnalyticsWorkspace -Name $Name
        }
        if ($Force){
            $ConfirmPreference = 'None'
        }
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess($SessionVariables.workspace)) {
                Write-Verbose "Performing the operation 'Removing workspace manager ...' on target '$Name'"
                if ($WorkspaceConfigurationName) { $Name = $WorkspaceConfigurationName }
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/$($Name)?api-version=$($SessionVariables.apiVersion)"
                
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