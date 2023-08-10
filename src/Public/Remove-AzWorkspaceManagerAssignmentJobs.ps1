function Remove-AzWorkspaceManagerAssignmentJobs {
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage = "It does not match expected pattern '{1}'")]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage = "It does not match expected pattern '{1}'")]
        [ValidateNotNullOrEmpty()]
        [string]$AssignmentName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage = "It does not match expected pattern '{1}'")]
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
            $null = Get-AzWorkspaceManager -Name $($WorkspaceName) -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManager -Name $($WorkspaceName)
        }

        if ($Force) {
            $ConfirmPreference = 'None'
        }

        try {
            Write-Verbose "Performing the operation 'Removing workspace manager assignment' on target '$($WorkspaceName)'."
            if ($ResourceId) {
                $uri = "https://management.azure.com$($ResourceId)?api-version=$($SessionVariables.apiVersion)"
                $name = $ResourceId.Split('/')[-1]
            } elseif ($Name -and $AssignmentName) {
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerAssignments/$($AssignmentName)/jobs/$($Name)?api-version=$($SessionVariables.apiVersion)"
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "No name for the workspace manager assignment or job was provided" -Severity 'Error'
            }

            $requestParam = @{
                Headers       = $authHeader
                Uri           = $uri
                Method        = 'GET'
                ErrorVariable = 'ErrVar'
            }


            if ($apiResponse -ne '') {
                if ($PSCmdlet.ShouldProcess($SessionVariables.workspaceManagerConfiguration -eq 'Enabled', "Remove Workspace Manager Assignment Job '$($Name)'")) {

                    $requestParam = @{
                        Headers       = $authHeader
                        Uri           = $uri
                        Method        = 'DELETE'
                        ErrorVariable = 'ErrVar'
                    }

                    Invoke-RestMethod @requestParam

                    if ($null -eq $response) {
                        Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "Workspace Manager Assignment Job '$($name)' was removed." -Severity 'Information'
                    }
                }
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "The Workspace Manager Assignment Job '$($name)' does not exist" -Severity 'Error'
            }
        }
        catch {
            if ($ErrVar.Message -like '*ResourceNotFound*') {
                Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "Workspace Manager Assignment Job '$($name)' was not found under Assignment '$($AssignmentName)'" -Severity 'Error'
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message ($return.ErrorRecord | ConvertFrom-Json).error.message -Severity 'Error'
            }
        }
    }
    <#
        .SYNOPSIS
        Get the Microsoft Sentinel Workspace Manager Groups
        .DESCRIPTION
        The Remove-AzWorkspaceManagerAssignmentJobs cmdlet removes the Workspace Manager Assignment Jobs from the Workspace Manager Assignment.
        When the Workspace Manager Assignment is removed, all the Workspace Manager Assignment Jobs are removed as well.
        .PARAMETER WorkspaceName
        The Name of the log analytics workspace
        .PARAMETER ResourceGroupName
        The name of the ResouceGroup where the log analytics workspace is located
        .PARAMETER AssignmentName
        The name of the workspace manager assignment (default this has the same value as the Workspace Manager GroupName)
        .PARAMETER JobName
        The name of the Workspace Manager Assignment Job
        .PARAMETER Force
        Confirms the removal of the Workspace manager configuration
        .EXAMPLE
        Remove-AzWorkspaceManagerAssignmentJobs -WorkspaceName 'myWorkspace' -ResourceGroupName 'myRG' -AssignmentName 'myAssignment' -JobName 'e53fa65b-1e2d-48cd-b079-a596dc6ea5a1'

        This example removes the Workspace Manager Assignment Job 'e53fa65b-1e2d-48cd-b079-a596dc6ea5a1' from the Workspace Manager Assignment 'myAssignment' in the log analytics workspace 'myWorkspace' in the resource group 'myRG'
        .EXAMPLE
        Get-AzWorkspaceManagerAssignmentJobs -WorkspaceName 'myWorkspace' -Name 'MyWorkspaceManagerAssignment' | Remove-AzWorkspaceManagerAssignmentJobs -Force

        This example removes all the Workspace Manager Assignment Jobs from the Workspace Manager Assignment 'MyWorkspaceManagerAssignment' without prompting for confirmation
        .EXAMPLE
        Get-AzWorkspaceManagerAssignments -WorkspaceName 'sentinel-playground' | Get-AzWorkspaceManagerAssignmentJobs | Remove-AzWorkspaceManagerAssignmentJobs -Force

        This example removes all the Workspace Manager Assignment Jobs from all the Workspace Manager Assignments in the log analytics workspace 'sentinel-playground' without prompting for confirmation
    #>
}