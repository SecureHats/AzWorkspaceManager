function Add-AzWorkspaceManagerAssignmentJobs {
    <#
      .SYNOPSIS
      Adds a Microsoft Sentinel Workspace Manager Assignment Job
      .DESCRIPTION
      This function adds a workspace manager group and adds the child workspaces
      .PARAMETER WorkspaceName
      The name of the log analytics workspace
      .PARAMETER ResourceGroupName
      The name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER GroupName
      The name of the workspace manager group
      .PARAMETER Name
      The name of the workspace manager assignment. if no value is provided a GUID will be generated and added to the name groupname. 'myGroup(afbd324f-6c48-459c-8710-8d1e1cd03812)'
      .EXAMPLE
      Add-AzWorkspaceManagerAssignment -WorkspaceName "myWorkspace" -Name "AlertRules" -GroupName 'myGroup'
      Adds a Workspace Manager Assignment to the workspace with the name 'AlertRules' and assigns this to the group 'myGroup'.
      .EXAMPLE
      Add-AzWorkspaceManagerAssignment -WorkspaceName "myWorkspace" -GroupName 'myGroup'
      Adds a Workspace Manager Assignment to the workspace with the name 'myGroup(<GUID>)' and assigns this to the group 'myGroup'.
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$WorkspaceName, # //TODO: Add validation for workspace name

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [array]$Name = (New-Guid).Guid
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

        if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
            try {
                Write-Verbose "Adding Workspace Manager Assignment Job to group '$Name'"
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerAssignments/$($Name)/jobs?api-version=$($SessionVariables.apiVersion)"
                write-host $uri

                $requestParam = @{
                    Headers       = $authHeader
                    Uri           = $uri
                    Method        = 'POST'
                    ErrorVariable = 'ErrVar'
                }
                
                $apiResponse = Invoke-RestMethod @requestParam
                if ($apiResponse -eq '') {Write-Host 'An Error in the response occured'}
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
                # if ($ErrVar.Message -like '*existing Assignment*') {
                #     Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message (($ErrVar.ErrorRecord) | ConvertFrom-Json).error.message -Severity 'Error'
                # }
                # else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $ErrVar.Message -Severity 'Error'
                # }
            }
        }
        else {
            Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "The Workspace Manager configuration is not 'Enabled' for workspace '$($WorkspaceName)'" -Severity 'Information'
        }
    }
}
#  /subscriptions/7570c6f7-9ca9-409b-aeaf-cb0f5ac1ad50/resourceGroups/dev-sentinel/providers/Microsoft.OperationalInsights/workspaces/sentinel-playground/providers/Microsoft.SecurityInsights/alertRules/95204744-39a6-4510-8505-ef13549bc0da