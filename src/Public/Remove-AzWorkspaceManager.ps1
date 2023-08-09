function Remove-AzWorkspaceManager {
    <#
      .SYNOPSIS
      Remove Microsoft Sentinel Workspace Manager
      .DESCRIPTION
      The Remove-AzWorkspaceManager cmdlet retrieves a Workspace Manager Configuration and removes
      it from the Log Analytics workspace. You can remove the workspace manager configuration by
      just providing a workspacename.
      .PARAMETER Name
      The Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      The name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER Force
      Confirms the removal of the Workspace manager configuration.
      .EXAMPLE
      This command removes the workspace manager on the Sentinel workspace 'myWorkspace'

      Remove-AzWorkspaceManager -Name 'myWorkspace'


      .EXAMPLE
      This command creates / enables the workspace manager on the Sentinel workspace 'myWorkspace'
      
      Remove-AzWorkspaceManager -Name 'myWorkspace'


    #>
    [cmdletbinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$Name,

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
            Write-Verbose "!!Resource Group Name: $ResourceGroupName"
            $null = Get-AzWorkspaceManager -Name $Name -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManager Name $Name
        }
        if ($Force){
            $ConfirmPreference = 'None'
        }
        
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