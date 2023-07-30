function Remove-AzWorkspaceManagerMembers {
    <#
      .SYNOPSIS
      Remove Azure Sentinel Workspace Manager
      .DESCRIPTION
      This function removes a Microsoft Sentinel Workspace Manager Member
      .PARAMETER Name
      The Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      The name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER WorkspaceManagerMemberName
      The name of the workspace manager member to remove from the workspace name.
      .PARAMETER Force
      Confirms the removal of the Workspace manager configuration.
      .EXAMPLE
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [string]$workspaceManagerMemberName,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
        if ($ResourceGroupName) {
            $null = Get-AzWorkspaceManagerConfiguration -WorkspaceName $Name -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManagerConfiguration -WorkspaceName $Name
        }
        if ($Force) {
            $ConfirmPreference = 'None'
        }
    }

    process {
        if ($PSCmdlet.ShouldProcess($SessionVariables.workspaceManagerConfiguration -eq 'Enabled')) {
            try {
                
                Write-Verbose "Performing the operation 'Removing workspace manager member...' on target '$Name'"
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerMembers/$($workspaceManagerMemberName)?api-version=$($SessionVariables.apiVersion)"

                $requestParam = @{
                    Headers = $authHeader
                    Uri     = $uri
                    Method  = 'DELETE'
                }
                
                $reponse = Invoke-RestMethod @requestParam
                return $reponse
                
            }
            catch {
                $reponse = $_.Exception.Message
                Write-Output $reponse
            }
        }
        else {
            Write-Host "$($MyInvocation.MyCommand.Name): The Workspace Manager configuration is not 'Enabled' for workspace '$($Name)'"
        }
    }
}