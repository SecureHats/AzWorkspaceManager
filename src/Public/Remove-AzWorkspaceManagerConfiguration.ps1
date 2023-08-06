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
      .PARAMETER Force
      Confirms the removal of the Workspace manager configuration.
      .EXAMPLE
    #>
    [cmdletbinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$ResourceGroupName,

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
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "No valid Workspace Manager configuration found" -Severity 'Error'
            }
        }
        catch {
            Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $($_.Exception.Message) -Severity 'Error'
        }
    }
}