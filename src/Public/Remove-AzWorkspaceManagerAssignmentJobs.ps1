function Remove-AzWorkspaceManagerAssignmentJobs {
    <#
      .SYNOPSIS
      Get the Microsoft Sentinel Workspace Manager Groups
      .DESCRIPTION
      This function gets the Workspace Manager Groups and properties
      .PARAMETER WorkspaceName
      The Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      The name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER AssignmentName
      The name of the workspace manager assignment (default this has the same value as the Workspace Manager GroupName)
      .PARAMETER Name
      The name of the Workspace Manager Assignment Job
      .PARAMETER Force
      Confirms the removal of the Workspace manager configuration 
      .EXAMPLE
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$WorkspaceName,    

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$AssignmentName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
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
            $null = Get-AzWorkspaceManagerConfiguration -WorkspaceName $($WorkspaceName) -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManagerConfiguration -WorkspaceName $($WorkspaceName)
        }
        
        if ($Force) {
            $ConfirmPreference = 'None'
        }

        try {     
            Write-Verbose "Performing the operation 'Removing workspace manager assignment' on target '$($WorkspaceName)'."
            foreach ($id in $ResourceId) {
                # Write-Host "Removing workspace manager assignment job '$($value)' from assignment '$($AssignmentName)'" -ForegroundColor Yellow
                $uri = "https://management.azure.com$($id)?api-version=$($SessionVariables.apiVersion)"
                $requestParam = @{
                    Headers       = $authHeader
                    Uri           = $uri
                    Method        = 'GET'
                    ErrorVariable = 'ErrVar'
                }

                if ($Name) {
                    $apiResponse = (Invoke-RestMethod @requestParam)
                } 
                else {
                    $apiResponse = (Invoke-RestMethod @requestParam).value
                }

                if ($apiResponse -ne '') {
                    if ($PSCmdlet.ShouldProcess($SessionVariables.workspaceManagerConfiguration -eq 'Enabled')) {    
                        
                        $requestParam = @{
                            Headers       = $authHeader
                            Uri           = $uri
                            Method        = 'DELETE'
                            ErrorVariable = 'ErrVar'
                        }

                        Invoke-RestMethod @requestParam
        
                        if ($null -eq $response) {
                            Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "Workspace Manager Assignment Job '$($value)' was removed from Assignment '$($AssignmentName)'" -Severity 'Information'
                        }
                    }
                }
                else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "The Workspace Manager Assignment Job '$($value)' does not exist" -Severity 'Error'
                }
            }
        }
        catch {
            if ($ErrVar.Message -like '*ResourceNotFound*') {
                Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "Workspace Manager Assignment Job '$($value)' was not found under Assignment '$($AssignmentName)'" -Severity 'Error'
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $_.Exception.Message -Severity 'Error'
            }
        }
    }
}