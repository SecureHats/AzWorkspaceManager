function Get-AzWorkspaceManagerMembers {
    <#
      .SYNOPSIS
      Gets a Microsoft Sentinel Workspace Manager Member
      .DESCRIPTION
      The Get-AzWorkspaceManagerMembers cmdlet gets workspace manager member(s) from the configuration.
      The members can be queried by providing a workspace name or by providing a workspace manager member name.
      .PARAMETER WorkspaceName
      Enter the Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      Enter the name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER Name
      Enter the name of the workspace manager member
      .EXAMPLE
      Get-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace"

      This command gets the workspace manager member(s) from the workspace configuration 'myWorkspace'
      .EXAMPLE
      Get-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" -Name "myChildWorkspace(***)"

      This command gets the workspace manager member myChildWorkspace from the workspace configuration 'myWorkspace'
      .NOTES
      This command currently not supports pipeline input
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage = "It does not match expected pattern '{1}'")]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$Name
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

        if ($null -eq $Name) {
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerMembers?api-version=$($SessionVariables.apiVersion)"
        }
        else {
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerMembers/$($Name)?api-version=$($SessionVariables.apiVersion)"
        }

        if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
            try {
                Write-Verbose "Get Workspace Manager Member(s) for workspace [$($WorkspaceName)]"
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
                    $result = Format-Result -Message $apiResponse
                    return $result
                }
                else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) "No Workspace Manager Member(s) found for workspace [$($WorkspaceName)]" -Severity 'Information'
                    break
                }
            }
            catch {
                $SessionVariables.workspace = $null
                if ($ErrVar.Message -like '*ResourceNotFound*') {
                    Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "Workspace Manager Member '$($Name)' was not found under workspace '$WorkspaceName'" -Severity 'Error'
                }
                else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $_.Exception.Message -Severity 'Error'
                }
                break
            }
        }
        else {
            Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "The Workspace Manager configuration is not 'Enabled' for workspace '$($WorkspaceName)'" -Severity 'Information'
            break
        }
    }
}