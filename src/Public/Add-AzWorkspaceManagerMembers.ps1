function Add-AzWorkspaceManagerMembers {
    <#
      .SYNOPSIS
      Add a Microsoft Sentinel Workspace Manager Member
      .DESCRIPTION
      The Add-AzWorkspaceManagerMembers cmdlet adds a workspace manager member to the configuration.
      These members are workspaces that are linked to the workspace manager configuration. and used to
      provision Microsoft Sentinel workspaces.
      The Workspace Manager Member name is constructed as follows: <workspaceName>(<subscriptionId>)
      .PARAMETER WorkspaceName
      The Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      The name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER ResourceId
      The ResourceId of the target workspace to add as a member
      .PARAMETER TenantId
      The TenantId of the target workspace to add as a member
      .EXAMPLE
      Add-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" -ResourceId "/subscriptions/***/resourcegroups/myRemoteRG/providers/microsoft.operationalinsights/workspaces/myChildWorkspace" -TenantId "***"


      Name              : myChildWorkspace(***)
      ResourceGroupName : myRG
      ResourceType      : Microsoft.SecurityInsights/workspaceManagerMembers
      WorkspaceName     : myWorkspace
      ResourceId        : /subscriptions/***/resourceGroups/myRG/providers/Microsoft.OperationalInsights/workspaces/myWorkspace/providers/Microsoft.SecurityInsights/workspaceManagerMembers/myChildWorkspace(***)
      Tags              :
      Properties        : @{targetWorkspaceResourceId=/subscriptions/***/resourceGroups/myRemoteRG/providers/Microsoft.OperationalInsights/workspaces/myChildWorkspace; targetWorkspaceTenantId=***}

      This example adds a Workspace Manager Member for the workspace with the name 'myWorkspace' and adds the workspace with the name 'myChildWorkspace' as a member.
      .EXAMPLE
      $resourceIds = @("/subscriptions/***/resourcegroups/myRemoteRG/providers/microsoft.operationalinsights/workspaces/myChildWorkspace", "/subscriptions/***/resourcegroups/myRemoteRG/providers/microsoft.operationalinsights/workspaces/myOtherWorkspace")

      PS > Add-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" -ResourceId $resourceIds -TenantId "***"


      Name              : myChildWorkspace(***)
      ResourceGroupName : myRG
      ResourceType      : Microsoft.SecurityInsights/workspaceManagerMembers
      WorkspaceName     : myWorkspace
      ResourceId        : /subscriptions/***/resourceGroups/myRG/providers/Microsoft.OperationalInsights/workspaces/myWorkspace/providers/Microsoft.SecurityInsights/workspaceManagerMembers/myChildWorkspace(***)
      Tags              :
      Properties        : @{targetWorkspaceResourceId=/subscriptions/***/resourceGroups/myRemoteRG/providers/Microsoft.OperationalInsights/workspaces/myChildWorkspace; targetWorkspaceTenantId=***}


      Name              : myChildWorkspace(***)
      ResourceGroupName : myRG
      ResourceType      : Microsoft.SecurityInsights/workspaceManagerMembers
      WorkspaceName     : myWorkspace
      ResourceId        : /subscriptions/***/resourceGroups/myRG/providers/Microsoft.OperationalInsights/workspaces/myWorkspace/providers/Microsoft.SecurityInsights/workspaceManagerMembers/myOtherWorkspace(***)
      Tags              :
      Properties        : @{targetWorkspaceResourceId=/subscriptions/***/resourceGroups/myRemoteRG/providers/Microsoft.OperationalInsights/workspaces/myOtherWorkspace; targetWorkspaceTenantId=***}
      This example adds a multiple Members from from an array into the workspace manager with the name 'myWorkspace'
      .NOTES
      The Workspace Manager Member name is constructed as follows: <workspaceName>(<subscriptionId>)
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [array]$ResourceId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidatePattern('^[{]?[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}[}]?$', ErrorMessage="It is not a valid GUID")]
        [string]$TenantId
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

        foreach ($id in $ResourceId) {

            $Name = "$($id.Split('/')[-1])($($id.Split('/')[2]))"

            $payload = @{
                properties = @{
                    targetWorkspaceResourceId = $id
                    targetWorkspaceTenantId   = $TenantId
                }
            } | ConvertTo-Json -Compress

            Write-Verbose $payload
            if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
                try {
                    Write-Verbose "Adding Workspace Manager Member to workspace [$WorkspaceName)]"
                    $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerMembers/$($Name)?api-version=$($SessionVariables.apiVersion)"

                    $requestParam = @{
                        Headers       = $authHeader
                        Uri           = $uri
                        Method        = 'PUT'
                        Body          = $payload
                        ContentType   = 'application/json'
                        ErrorVariable = "ErrVar"
                    }

                    $apiResponse = Invoke-RestMethod @requestParam

                    if ($apiResponse -ne '') {
                        [array]$result += Format-Result -Message $apiResponse
                    }
                    else {
                        Write-Output "$($MyInvocation.MyCommand.Name): $_.Exception.Message"
                    }
                }
                catch {
                    if ($ErrVar.Message -like '*LinkedAuthorizationFailed*') {
                        Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "Unable to link workspace in tenant '$tenantId'. Check if the ResourceId is correct and the the account has permissions" -Severity 'Error'
                    }
                    elseif ($ErrVar.Message -like '*InternalServerError*') {
                        Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "Unable to connect to tenant '$tenantId'" -Severity 'Error'
                    } else {
                        Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $_.Exception.Message -Severity 'Error'
                    }
                }
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "The Workspace Manager configuration is not 'Enabled' for workspace '$($WorkspaceName)'" -Severity 'Information'
            }
        }
        return $result
    }
}