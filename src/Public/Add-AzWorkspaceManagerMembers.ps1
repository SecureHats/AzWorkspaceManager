function Add-AzWorkspaceManagerMembers {
    <#
      .SYNOPSIS
      Add a Microsoft Sentinel Workspace Manager Member
      .DESCRIPTION
      With this function you can add a Microsoft Sentinel Workspace Manager Member
      .PARAMETER WorkspaceName
      The Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      The name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER targetWorkspaceResourceId
      The ResourceId of the target workspace to add as a member
      .PARAMETER targetWorkspaceTenantId
      The TenantId of the target workspace to add as a member
      .EXAMPLE
      Add-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" -targetWorkspaceResourceId "/subscriptions/***/resourcegroups/***/providers/microsoft.operationalinsights/workspaces/myWorkspace" -targetWorkspaceTenantId "***"
      
      This example adds a Workspace Manager Member for the workspace with the name 'myWorkspace' and adds the workspace with the name 'myWorkspace' as a member.
      
      Name              : MyChildWorkspace(***)
      ResourceGroupName : MyRg
      ResourceType      : Microsoft.SecurityInsights/workspaceManagerMembers
      ResourceId        : /subscriptions/***/resourceGroups/MyRg/providers/M
                          icrosoft.OperationalInsights/workspaces/muWorkspac
                          e/providers/Microsoft.SecurityInsights/workspaceMa
                          nagerMembers/myChildWorkspace(***)
      Tags              : 
      Properties        : @{targetWorkspaceResourceId=/subscriptions/***/reso
                          urceGroups/myRg/providers/Microsoft.OperationalInsi
                          ghts/workspaces/myChildWorkspace; targetWorkspaceTe
                          nantId=***}
      .NOTES
      The Workspace Manager Member name is constructed as follows: <workspaceName>(<subscriptionId>)
      #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$targetWorkspaceResourceId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$targetWorkspaceTenantId
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
        if ($ResourceGroupName) {
            $null = Get-AzWorkspaceManagerConfiguration -WorkspaceName $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManagerConfiguration -WorkspaceName $WorkspaceName
        }
    }

    process {

        $workspaceManagerMemberName = "$($targetWorkspaceResourceId.Split('/')[-1])($($targetWorkspaceResourceId.Split('/')[2]))"
        $payload = @{
            properties = @{
                targetWorkspaceResourceId = $targetWorkspaceResourceId
                targetWorkspaceTenantId   = $targetWorkspaceTenantId
            }
        } | ConvertTo-Json

        if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
            try {
                Write-Verbose "Adding Workspace Manager Member to workspace [$WorkspaceName)]"
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerMembers/$($workspaceManagerMemberName)?api-version=$($SessionVariables.apiVersion)"
            
                $requestParam = @{
                    Headers     = $authHeader
                    Uri         = $uri
                    Method      = 'PUT'
                    Body        = $payload
                    ContentType = 'application/json'
                }
            
                $apiResponse = Invoke-RestMethod @requestParam
        
                if ($apiResponse -ne '') {
                    $split = $apiResponse.id.Split('/')
                    $result = [ordered]@{
                        Name              = $split[-1]
                        ResourceGroupName = $split[-9]
                        ResourceType      = '{0}/{1}' -f $split[-3], $split[-2]
                        ResourceId        = $apiResponse.id
                        Tags              = $apiResponse.tags
                        Properties        = $apiResponse.properties
                    } | ConvertTo-Json | ConvertFrom-Json
                    return $result
                }
                else {
                    Write-Output "$($MyInvocation.MyCommand.Name): $_.Exception.Message"
                }
            }
            catch {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $($_.Exception.Message) -Severity 'Error'
            }
        }
        else {
            Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "The Workspace Manager configuration is not 'Enabled' for workspace '$($WorkspaceName)'" -Severity 'Information'
        }
    }
}