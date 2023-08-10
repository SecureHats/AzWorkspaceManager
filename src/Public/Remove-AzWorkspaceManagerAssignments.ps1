function Remove-AzWorkspaceManagerAssignments {
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$Name,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [array]$ResourceId,

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

        Write-Debug "WorkspaceName: $($WorkspaceName)"
        Write-Debug "ResourceGroupName: $($ResourceGroupName)"
        Write-Debug "Name: $($Name)"
        Write-Debug "ResourceId: $($ResourceId)"

        try {
            if ($ResourceId) {
                $uri = "https://management.azure.com$($ResourceId)?api-version=$($SessionVariables.apiVersion)"
                $Name = $ResourceId.Split('/')[-1]
            }
            elseif ($Name) {
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerAssignments/$($Name)?api-version=$($SessionVariables.apiVersion)"
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "No name for the workspace manager assignment was provided" -Severity 'Error'
            }
            Write-Debug "Performing the operation 'Removing workspace manager assignment'"
            Write-Debug "Request URI: $($uri)"

            $requestParam = @{
                Headers       = $authHeader
                Uri           = $uri
                Method        = 'GET'
                ErrorVariable = 'ErrVar'
            }

            $apiResponse = Invoke-RestMethod @requestParam

            if ($apiResponse -ne '') {
                if ($PSCmdlet.ShouldProcess($SessionVariables.workspaceManagerConfiguration -eq 'Enabled', "Remove Workspace Manager Assignment '$Name'")) {
                    $requestParam = @{
                        Headers       = $authHeader
                        Uri           = $uri
                        Method        = 'DELETE'
                        ErrorVariable = 'ErrVar'
                    }

                    Write-Verbose "Performing the operation 'Removing workspace manager assignment'"
                    Write-Verbose "Request URI: $($uri)"
                    Invoke-RestMethod @requestParam

                    Write-Host $response
                    if ($null -eq $response) {
                        Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "Workspace Manager Assignment '$($Name)' was removed from workspace '$WorkspaceName'" -Severity 'Information'
                    }
                }
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "The Workspace Manager Assignment '$($Name)' does not exist" -Severity 'Error'
            }
        }
        catch {
            if ($ErrVar.Message -like '*ResourceNotFound*') {
                Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "Workspace Manager Assignment '$($Name)' was not found under workspace '$WorkspaceName'" -Severity 'Error'
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message ($_.Exception.ErrorRecord | ConvertFrom-Json).error.message -Severity 'Error'
            }
        }
    }
    <#
        .SYNOPSIS
        Remove Microsoft Sentinel Workspace Manager Assignment
        .DESCRIPTION
        The Remove-AzWorkspaceManagerAssignments cmdlet removes a Workspace Manager Assignment from a Microsoft Sentinel Workspace.
        The cmdlet will not return an error if the Workspace Manager Assignment does not exist.
        The Assignment must first be removed from the Workspace Manager Group before the group can be removed.
        .PARAMETER WorkspaceName
        The Name of the log analytics workspace
        .PARAMETER ResourceGroupName
        The name of the ResouceGroup where the log analytics workspace is located
        .PARAMETER Name
        The Name of the Workspace Manager Assignment
        .PARAMETER Force
        Confirms the removal of the Workspace manager configuration.
        .EXAMPLE
        Remove-AzWorkspaceManagerAssignments -WorkspaceName 'myWorkspace' -ResourceGroupName 'myRG' -Name 'myAssignment'

        This command removes the Workspace Manager Assignment 'myAssignment' from the workspace 'ContosoWorkspace' in the resource group 'myRG'.
        .EXAMPLE
        Get-AzWorkspaceManagerAssignments -WorkspaceName 'myWorkspace' | Remove-AzWorkspaceManagerAssignments -Force

        This example removes all Workspace Manager Assignments from the workspace 'ContosoWorkspace' in the resource group 'myRG' without prompting for confirmation.
        .LINK
        Get-AzWorkspaceManagerAssignments
        Remove-AzWorkspaceManagerAssignments
    #>
}