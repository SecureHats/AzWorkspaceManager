function Remove-AzWorkspaceManagerMember {
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters.ResourceNameCompleterAttribute(
            "Microsoft.OperationalInsights/workspaces",
            "ResourceGroupName"
        )][string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters.ResourceGroupCompleterAttribute()]
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
            if ($ResourceId) {
                $uri = "https://management.azure.com$($ResourceId)?api-version=$($SessionVariables.apiVersion)"
                $name = $ResourceId.Split('/')[-1]
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
                if ($PSCmdlet.ShouldProcess($SessionVariables.workspaceManagerConfiguration -eq 'Enabled', "Remove Workspace Manager Member '$($Name)")) {
                    $requestParam = @{
                        Headers       = $authHeader
                        Uri           = $uri
                        Method        = 'DELETE'
                        ErrorVariable = 'ErrVar'
                    }

                    Invoke-RestMethod @requestParam

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
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message ($return.ErrorRecord | ConvertFrom-Json).error.message -Severity 'Error'
            }
        }
    }
    <#
      .SYNOPSIS
      Remove a Workspace Manager Member
      .DESCRIPTION
      The Remove-AzWorkspaceManagerMember cmdlet removes a workspace manager member to the configuration.
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
      .EXAMPLE
      Remove-AzWorkspaceManagerMember -WorkspaceName "myWorkspace" -Name "myChildWorkspace(***)"

      This example removes the workspace manager member myChildWorkspace from the workspace configuration 'myWorkspace' with confirmation
      .EXAMPLE
      Remove-AzWorkspaceManagerMember -WorkspaceName "myWorkspace" -ResourceGroup "myRG" -Name "myChildWorkspace(***)" -Force

      This example removes the workspace manager member myChildWorkspace from the workspace configuration 'myWorkspace' without confirmation
      .EXAMPLE
      Get-AzWorkspaceManagerMember -WorkspaceName "myWorkspace" | Remove-AzWorkspaceManagerMember -Force

      This example removes all workspace manager members from the workspace configuration 'myWorkspace' using pipeline input without confirmation
      .LINK
      Get-AzWorkspaceManagerMember
      Add-AzWorkspaceManagerMember
    #>
}