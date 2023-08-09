function Get-AzWorkspaceManagerAssignmentJobs {
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
      The name of the workspace manager assignment (default this has the same value as the Workspace Manager GroupName)
      .PARAMETER JobName
      The name of the Workspace Manager Assignment Job 
      .EXAMPLE
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
[ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$Name,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$JobName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
    }

    process {
        if ($ResourceGroupName) {
            $null = Get-AzWorkspaceManager -WorkspaceName $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManager -WorkspaceName $WorkspaceName
        }

        #$null = Get-AzWorkspaceManagerAssignments -WorkspaceName $WorkspaceName -Name $Name

        if ($ResourceId) {
            $uri = "https://management.azure.com$($ResourceId)/jobs?api-version=$($SessionVariables.apiVersion)"
            Write-Debug "$($MyInvocation.MyCommand.Name): $uri"
        } else {
            if ($null -ne $JobName) {
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerAssignments/$($Name)/jobs/$($JobName)?api-version=$($SessionVariables.apiVersion)"
            }
            else {
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerAssignments/$($Name)/jobs?api-version=$($SessionVariables.apiVersion)"
            }
        }

        if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
            try {
                Write-Verbose "List Microsoft Sentinel Workspace Manager Assignments Jobs for workspace '$WorkspaceName'"

                $requestParam = @{
                    Headers       = $authHeader
                    Uri           = $uri
                    Method        = 'GET'
                    ErrorVariable = 'ErrVar'
                }

                if ($Name -eq '' -and $ResourceId -eq '') {
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
                                ResourceGroupName = $split[-11]
                                ResourceType      = '{0}/{1}/{2}' -f $split[-5], $split[-4], $split[-2]
                                WorkspaceName     = $WorkspaceName
                                ResourceId        = $object.id
                                Properties        = $object.properties
                            } | ConvertTo-Json -Depth 20 | ConvertFrom-Json -Depth 20
                        )
                    }
                    
                    return $result
                }
                else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "No Workspace Manager Assignments Jobs found for workspace '$WorkspaceName'" -Severity 'Information'
                    break
                }
            }
            catch {
                if ($ErrVar.Message -like '*ResourceNotFound*') {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "No Workspace Manager Assignment Job with name '$($JobName)' found for Assignment Group '$($Name)'" -Severity 'Error'
                }
                else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $($_.Exception.Message) -Severity 'Error'
                }
            }
        }
        else {
            Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "The Workspace Manager configuration is not 'Enabled' for workspace '$WorkspaceName'" -Severity 'Information'
        }
    }
}