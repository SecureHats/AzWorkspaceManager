function Get-AzWorkspaceManagerMembers {
    <#
      .SYNOPSIS
      Add a Microsoft Sentinel Workspace Manager Member
      .DESCRIPTION
      With this function you can add a Microsoft Sentinel Workspace Manager Member
      .PARAMETER WorkspaceName
      Enter the Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      Enter the name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER Name
      Enter the name of the workspace manager member
      .EXAMPLE
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
    }

    process {
        if ($ResourceGroupName) {
            $null = Get-AzWorkspaceManagerConfiguration -WorkspaceName $WorkspaceName -ResourceGroupName $ResourceGroupName
        } 
        else {
            $null = Get-AzWorkspaceManagerConfiguration -WorkspaceName $WorkspaceName
        }

        if ($Name) {
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerMembers/$($Name)?api-version=$($SessionVariables.apiVersion)"
        } 
        else {
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerMembers?api-version=$($SessionVariables.apiVersion)"
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