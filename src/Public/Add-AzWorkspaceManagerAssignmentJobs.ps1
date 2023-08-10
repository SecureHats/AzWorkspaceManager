function Add-AzWorkspaceManagerAssignmentJobs {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$WorkspaceName, # //TODO: Add validation for workspace name

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$Name,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [array]$ResourceId
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

        if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
            try {
                if ($ResourceId) {
                    $uri = "https://management.azure.com$($ResourceId)/jobs?api-version=$($SessionVariables.apiVersion)"
                    $name = $ResourceId.Split('/')[-1]
                }
                elseif ($Name) {
                    $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerAssignments/$($Name)/jobs?api-version=$($SessionVariables.apiVersion)"
                }
                else {
                    Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "No name was provided for the Workspace Manager Assignment Job. The name will be the same as the Workspace Manager Assignment" -Severity 'Information'
                }
                Write-Verbose "Adding Workspace Manager Assignment Job to group '$Name'"

                write-host $uri

                $requestParam = @{
                    Headers       = $authHeader
                    Uri           = $uri
                    Method        = 'POST'
                    ErrorVariable = 'ErrVar'
                }

                $apiResponse = Invoke-RestMethod @requestParam
                if ($apiResponse -ne '') {
                    $split = $apiResponse.id.Split('/')
                    $result = [ordered]@{
                        Name              = $split[-1]
                        ResourceGroupName = $split[-11]
                        ResourceType      = '{0}/{1}/{2}' -f $split[-5], $split[-4], $split[-2]
                        ResourceId        = $apiResponse.id
                        Properties        = $apiResponse.properties
                    } | ConvertTo-Json | ConvertFrom-Json
                    return $result
                }
                else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $($_.Exception.Message) -Severity 'Error'
                    break
                }
            }
            catch {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message ($ErrVar.Message | ConvertFrom-Json).error.message -Severity 'Error'
            }
        }
        else {
            Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "The Workspace Manager configuration is not 'Enabled' for workspace '$($WorkspaceName)'" -Severity 'Information'
        }
    }
    <#
        .SYNOPSIS
        Adds a Microsoft Sentinel Workspace Manager Assignment Job
        .DESCRIPTION
        The Add-AzWorkspaceManagerAssignmentJobs command adds a Workspace Manager Assignment Job to the workspace.
        By default the name of the Workspace Manager Assignment is the same as the Workspace Manager Group.
        .PARAMETER WorkspaceName
        The name of the log analytics workspace
        .PARAMETER ResourceGroupName
        The name of the ResouceGroup where the log analytics workspace is located
        .PARAMETER Name
        The name of the workspace manager assignment. This is the same as the Workspace Manager GroupName unless specified otherwise
        .EXAMPLE
        Add-AzWorkspaceManagerAssignmentJobs -WorkspaceName 'MyWorkspace' -Name 'MyWorkspaceManagerAssignment'

        This example adds a Workspace Manager Assignment Job to the workspace 'MyWorkspace' with the name 'MyWorkspaceManagerAssignment'
        .EXAMPLE
        Add-AzWorkspaceManagerAssignmentJobs -WorkspaceName 'MyWorkspace' -ResourceGroupName 'MyResourceGroup'

        This example adds a Workspace Manager Assignment Job to the workspace 'MyWorkspace' in the resourcegroup 'MyResourceGroup' with the name 'MyWorkspaceManagerAssignment'
        .EXAMPLE
        Get-AzWorkspaceManagerAssignments -WorkspaceName 'MyWorkspace' | Add-AzWorkspaceManagerAssignmentJobs

        This example adds a Workspace Manager Assignment Job to the workspace 'MyWorkspace' for each Workspace Manager Assignment found
        .LINK
        Get-AzWorkspaceManagerAssignmentJobs
        Remove-AzWorkspaceManagerAssignmentJobs
#>
}