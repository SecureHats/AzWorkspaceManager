function Get-AzWorkspaceManagerAssignments {
    <#
      .SYNOPSIS
      Get the Microsoft Sentinel Workspace Manager Groups
      .DESCRIPTION
      This function gets the Workspace Manager Groups and properties
      .PARAMETER WorkspaceName
      The Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      The name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER Name
      The name of the workspace manager assignment
      .EXAMPLE
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
        if ($ResourceGroupName) {
            $null = Get-AzWorkspaceManagerConfiguration -WorkspaceName $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManagerConfiguration -WorkspaceName $WorkspaceName
        }

        if ($null -ne $Name) {
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerAssignments/$($Name)?api-version=$($SessionVariables.apiVersion)"
        }
        else {
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerAssignments?api-version=$($SessionVariables.apiVersion)"
        }
    }

    process {
        if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
            try {
                Write-Verbose "List Microsoft Sentinel Workspace Manager Assignments for workspace '$WorkspaceName'"

                $requestParam = @{
                    Headers = $authHeader
                    Uri     = $uri
                    Method  = 'GET'
                }
                if ($Name) {
                    $apiResponse = (Invoke-RestMethod @requestParam)
                } 
                else {
                    $apiResponse = (Invoke-RestMethod @requestParam).value
                }

                if ($apiResponse -ne '') {
                    foreach ($object in $apiResponse) {
                        $split = $object.id.Split('/')
                        $result += @(
                            [ordered]@{
                                Name              = $split[-1]
                                ResourceGroupName = $split[-9]
                                ResourceType      = '{0}/{1}' -f $split[-3], $split[-2]
                                ResourceId        = $object.id
                                Tags              = $object.tags
                                Properties        = $object.properties
                            } | ConvertTo-Json -Depth 20 | ConvertFrom-Json -Depth 20
                        )
                    }
                    
                    return $result
                }
                else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "No Workspace Manager Assignments found for workspace '$WorkspaceName'" -Severity 'Information'
                }
            }
            catch {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $($_.Exception.Message) -Severity 'Error'
                break
            }
        }
        else {
            Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "The Workspace Manager configuration is not 'Enabled' for workspace '$WorkspaceName'" -Severity 'Information'
        }
    }
}