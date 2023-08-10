function Remove-AzWorkspaceManagerAssignments {
    <#
      .SYNOPSIS
      Remove Microsoft Sentinel Workspace Manager
      .DESCRIPTION
      This function removes a Microsoft Sentinel Workspace Manager Member
      .PARAMETER WorkspaceName
      The Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      The name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER Name
      The Name of the Workspace Manager Group
      .PARAMETER Force
      Confirms the removal of the Workspace manager configuration.
      .EXAMPLE
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$WorkspaceName,    

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
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
            Write-Verbose "Performing the operation 'Removing workspace manager assignment'"
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerAssignments/$($Name)?api-version=$($SessionVariables.apiVersion)"

            $requestParam = @{
                Headers       = $authHeader
                Uri           = $uri
                Method        = 'GET'
                ErrorVariable = 'ErrVar'
            }

            $apiResponse = Invoke-RestMethod @requestParam

            if ($apiResponse -ne '') {
                if ($PSCmdlet.ShouldProcess($SessionVariables.workspaceManagerConfiguration -eq 'Enabled', "Remove '$($Name)")) {    
                    $requestParam = @{
                        Headers       = $authHeader
                        Uri           = $uri
                        Method        = 'DELETE'
                        ErrorVariable = 'ErrVar'
                    }

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
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message ($return.ErrorRecord | ConvertFrom-Json).error.message -Severity 'Error'
            }
        }
    }
}