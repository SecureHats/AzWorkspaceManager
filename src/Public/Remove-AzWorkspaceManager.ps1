function Remove-AzWorkspaceManager {
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
            Write-Verbose "Resource Group Name: $ResourceGroupName"
            $null = Get-AzWorkspaceManager -Name $Name -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManager -Name $Name
        }
        if ($Force){
            $ConfirmPreference = 'None'
        }

        try {
            if ($PSCmdlet.ShouldProcess($SessionVariables.workspaceManagerConfiguration -eq 'Enabled', "Remove '$($Name)")) {
                Write-Verbose "Performing the operation 'Removing workspace manager ...' on target '$Name'"
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/$($Name)?api-version=$($SessionVariables.apiVersion)"

                $requestParam = @{
                    Headers = $authHeader
                    Uri     = $uri
                    Method  = 'DELETE'
                }

                $reponse = Invoke-RestMethod @requestParam
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "Workspace Manager Configuration '$Name' removed" -Severity 'Information'
                return $reponse
            }
            else {
                Write-Debug "User has aborted"
            }
        }
        catch {
            Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message ($return.ErrorRecord | ConvertFrom-Json).error.message -Severity 'Error'
        }
    }
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
    .LINK
    Get-AzWorkspaceManager
    Set-AzWorkspaceManager
    .EXAMPLE
    Remove-AzWorkspaceManager -Name 'myWorkspace' -Force

    This command removes the workspace manager on the Sentinel workspace 'myWorkspace'
    .EXAMPLE
    Remove-AzWorkspaceManager -Name sentinel-playground -Force

    Remove-AzWorkspaceManager: Workspace Manager Configuration 'sentinel-playground' removed
    This command removes the workspace manager on the Sentinel workspace 'myWorkspace' without confirmation'

    .EXAMPLE
    Get-AzWorkspaceManager -Name sentinel-playground | Remove-AzWorkspaceManager -Force

    Remove-AzWorkspaceManager: Workspace Manager Configuration 'sentinel-playground' removed
    This command removes the workspace manager based on a pipeline value from the Get-AzWorkspaceManager cmdlet
#>
}