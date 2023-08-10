function Get-AzWorkspaceManagerMembers {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage = "It does not match expected pattern '{1}'")]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)]
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
                    $result += Format-Result -Message $apiResponse
                    return $result
                }
                else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) "No Workspace Manager Member(s) found for workspace '$WorkspaceName'" -Severity 'Information'
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
    <#
        .SYNOPSIS
        Gets a Microsoft Sentinel Workspace Manager Member
        .DESCRIPTION
        The Get-AzWorkspaceManagerMembers cmdlet gets workspace manager member(s) from the configuration.
        If the workspace manager member name is not provided, all the workspace manager members for the workspace will be returned.
        When the workspace manager member name is provided, the workspace manager member details will be returned.
        .PARAMETER WorkspaceName
        Enter the Name of the log analytics workspace
        .PARAMETER ResourceGroupName
        Enter the name of the ResouceGroup where the log analytics workspace is located
        .PARAMETER Name
        Enter the name of the workspace manager member
        .LINK
        Add-AzWorkspaceManagerMembers
        Remove-AzWorkspaceManagerMembers
        .EXAMPLE
        Get-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace"

        This example gets the Microsoft Sentinel Workspace Manager Members for the workspace 'MyWorkspace'
        .EXAMPLE
        Get-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" -ResourceGroupName "myResourceGroup"

        This example gets the Microsoft Sentinel Workspace Manager Members for the workspace 'MyWorkspace' in the resource group 'myResourceGroup'
        .EXAMPLE
        Get-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" -Name "myChildWorkspace(***)"

        This example gets the Microsoft Sentinel Workspace Manager Member 'myChildWorkspace(***)' for the workspace 'MyWorkspace'
        .EXAMPLE
        Get-AzWorkspaceManager -Name "myWorkspace" | Get-AzWorkspaceManagerMembers

        This example gets the Microsoft Sentinel Workspace Manager Members for the workspace 'MyWorkspace' using pipeline
        .NOTES
        This command currently not supports pipeline input
    #>
}