function Remove-AzWorkspaceManagerMembers {
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage = "It does not match expected pattern '{1}'")]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$ResourceGroupName,

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
            $null = Get-AzWorkspaceManager -Name $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManager -Name $WorkspaceName
        }

        if ($Force) {
            $ConfirmPreference = 'None'
        }

        try {
            if ($null -ne $ResourceId) {
                $uri = "https://management.azure.com$($id)?api-version=$($SessionVariables.apiVersion)"
            }
            elseif ($Name) {
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerMembers/$($Name)?api-version=$($SessionVariables.apiVersion)"
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "No name for the workspace manager member was provided" -Severity 'Error'
            }

            Write-Verbose "Performing the operation 'Removing workspace manager member' on target '$Name'"
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerMembers/$($Name)?api-version=$($SessionVariables.apiVersion)"

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
                        Write-Message -Message "Workspace Manager Member '$($Name)' was removed from workspace '$WorkspaceName'" -Severity 'Information' -FunctionName $($MyInvocation.MyCommand.Name)
                    }
                }
                else {
                    Write-Debug "User has aborted"
                }
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "The Workspace Manager Member '$($Name)' was not found" -Severity 'Error'
            }
        }
        catch {
            if ($ErrVar.Message -like '*ResourceNotFound*') {
                Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "Workspace Manager Member '$($Name)' was not found under workspace '$WorkspaceName'" -Severity 'Error'
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $_.Exception.Message -Severity 'Error'
            }
        }
    }
    <#
      .SYNOPSIS
      Remove a Workspace Manager Member
      .DESCRIPTION
      The Remove-AzWorkspaceManagerMembers cmdlet removes a workspace manager member to the configuration.
      .PARAMETER WorkspaceName
      The Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      The name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER Name
      The Name of the Workspace Manager Member
      .PARAMETER ResourceId
      The ResourceId of the target workspace manager member to remove
      .PARAMETER Force
      Confirms the removal of the Workspace manager configuration.
      .LINK
      Get-AzWorkspaceManagerMembers
      Add-AzWorkspaceManagerMembers
      .EXAMPLE
      Remove-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" -Name "myChildWorkspace(***)"

      This command removes the workspace manager member myChildWorkspace from the workspace configuration 'myWorkspace'
      .EXAMPLE
      Remove-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" -ResourceGroup "myRG" -Name "myChildWorkspace(***)" -Force

      This command removes the workspace manager member myChildWorkspace from the workspace configuration 'myWorkspace' without confirmation
      .EXAMPLE
      Get-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" | Remove-AzWorkspaceManagerMembers -Force

      This command removes all workspace manager members from the workspace configuration 'myWorkspace' without confirmation
    #>
}