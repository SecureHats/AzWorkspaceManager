function Remove-AzWorkspaceManagerGroups {
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage = "It does not match expected pattern '{1}'")]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage = "It does not match expected pattern '{1}'")]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
    }

    process {

        if ($ResourceGroupName) {
            $null = Get-AzWorkspaceManager -Name $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManager -Name $WorkspaceName
        }

        if ($Force) {
            $ConfirmPreference = 'None'
        }

        try {
            Write-Verbose "Performing the operation 'Removing workspace manager group' on target '$Name'"
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerGroups/$($Name)?api-version=$($SessionVariables.apiVersion)"

            $requestParam = @{
                Headers       = $authHeader
                Uri           = $uri
                Method        = 'GET'
                ErrorVariable = 'ErrVar'
            }

            $apiResponse = Invoke-RestMethod @requestParam

            if ($apiResponse -ne '') {
                if ($PSCmdlet.ShouldProcess($SessionVariables.workspaceManagerConfiguration -eq 'Enabled', "Remove Workspace Manager Group $($Name)")) {
                    $requestParam = @{
                        Headers       = $authHeader
                        Uri           = $uri
                        Method        = 'DELETE'
                        ErrorVariable = 'ErrVar'
                    }

                    Invoke-RestMethod @requestParam

                    if ($null -eq $response) {
                        Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "Workspace Manager Group '$($Name)' was removed from workspace '$WorkspaceName'" -Severity 'Information'
                    }
                }
                else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "Workspace Manager Group '$($Name)' was not removed from workspace '$WorkspaceName'" -Severity 'Information'
                }
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "The Workspace Manager Group '$($Name)' does not exist" -Severity 'Error'
            }
        }
        catch {
            if ($ErrVar.Message -like '*ResourceNotFound*') {
                Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "Workspace Manager Group '$($Name)' was not found under workspace '$WorkspaceName'" -Severity 'Error'
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message ($return.ErrorRecord | ConvertFrom-Json).error.message -Severity 'Error'
            }
        }
    }
    <#
        .SYNOPSIS
        Remove Microsoft Sentinel Workspace Manager
        .DESCRIPTION
        This command removes a Workspace Manager Group from a Microsoft Sentinel Workspace.
        If the Workspace Manager Group does not exist, the command will return an error.
        When the Workspace Manager Group is removed the members of the group will no longer receive updates from the workspace.
        .PARAMETER WorkspaceName
        The Name of the log analytics workspace
        .PARAMETER ResourceGroupName
        The name of the ResouceGroup where the log analytics workspace is located
        .PARAMETER Name
        The Name of the Workspace Manager Group
        .PARAMETER Force
        Confirms the removal of the Workspace manager configuration.
        .EXAMPLE
        Remove-AzWorkspaceManagerGroups -WorkspaceName 'myWorkspace' -Name 'myChildWorkspace'
        This example removes the Workspace Manager Group 'myChildWorkspace' from the workspace 'myWorkspace'
        .EXAMPLE
        Remove-AzWorkspaceManagerGroups -WorkspaceName 'myWorkspace' -ResourceGroupName 'myWorkspaceManagerGroup' -Name 'myChildWorkspace' -Force

        This example removes the Workspace Manager Group 'myChildWorkspace' from the workspace 'myWorkspace' in the resource group 'myWorkspaceManagerGroup' without prompting for confirmation
        .EXAMPLE
        Get-AzWorkspaceManagerGroups -WorkspaceName 'myWorkspace' | Remove-AzWorkspaceManagerGroups -Force

        This example removes all Workspace Manager Groups from the workspace 'myWorkspace' without prompting for confirmation using the pipeline
    #>
}