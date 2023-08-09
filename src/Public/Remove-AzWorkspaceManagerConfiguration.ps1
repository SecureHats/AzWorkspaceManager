function Remove-AzWorkspaceManager {
    <#
      .SYNOPSIS
      Remove Microsoft Sentinel Workspace Manager
      .DESCRIPTION
      This function removes the Microsoft Sentinel Workspace Manager configuration
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
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
    }

    process {
        if ($ResourceGroupName) {
            $null = Get-AzWorkspaceManager -WorkspaceName $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManager -WorkspaceName $WorkspaceName
        }
        if ($Force){
            $ConfirmPreference = 'None'
        }
        
        try {
            if ($PSCmdlet.ShouldProcess($SessionVariables.workspace)) {
                Write-Verbose "Performing the operation 'Removing workspace manager ...' on target '$WorkspaceName'"
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/$($WorkspaceName)?api-version=$($SessionVariables.apiVersion)"
                
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