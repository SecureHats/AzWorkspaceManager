function Get-AzWorkspaceManagerAssignmentJob {
    [cmdletbinding()]
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

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$Name,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)]
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
            $null = Get-AzWorkspaceManager -Name $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManager -Name $WorkspaceName
        }

        if ($ResourceId) {
            $uri = "https://management.azure.com$($ResourceId)/jobs?api-version=$($SessionVariables.apiVersion)"
        } else {
            if ($Name -and $JobName) {
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerAssignments/$($Name)/jobs/$($JobName)?api-version=$($SessionVariables.apiVersion)"
            }
            elseif ($Name) {
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerAssignments/$($Name)/jobs?api-version=$($SessionVariables.apiVersion)"
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "No name for the workspace manager assignment or job was provided" -Severity 'Error'
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

                if ($JobName) {
                    $apiResponse = (Invoke-RestMethod @requestParam)
                }
                elseif ($ResourceId -or $Name ) {
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
    <#
        .SYNOPSIS
        Get the Microsoft Sentinel Workspace Manager Groups
        .DESCRIPTION
        The Get-AzWorkspaceManagerAssignmentJob cmdlet gets the Microsoft Sentinel Workspace Manager Assignment Jobs
        It can be used to get all the Workspace Manager Assignment Jobs or a specific Workspace Manager Assignment Job by specifying the JobName.
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
}