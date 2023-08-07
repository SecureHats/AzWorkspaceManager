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
      .PARAMETER ResourceId
      The ResourceId of the target workspace to add as a member
      .PARAMETER TenantId
      The TenantId of the target workspace to add as a member
      .EXAMPLE
      Add-AzWorkspaceManagerMembers -WorkspaceName "myWorkspace" -ResourceId "/subscriptions/***/resourcegroups/***/providers/microsoft.operationalinsights/workspaces/myWorkspace" -TenantId "***"
      
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
        [string]$ResourceId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$TenantId
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
        
        $Name = "$($ResourceId.Split('/')[-1])($($ResourceId.Split('/')[2]))"
        
        $payload = @{
            properties = @{
                targetWorkspaceResourceId = $ResourceId
                targetWorkspaceTenantId   = $TenantId
            }
        } | ConvertTo-Json -Compress

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
                    $result = Format-Result -Message $apiResponse
                    return $result
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
}