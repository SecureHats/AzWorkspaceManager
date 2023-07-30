function Add-AzWorkspaceManagerMembers {
    <#
      .SYNOPSIS
      Add a Microsoft Sentinel Workspace Manager Member
      .DESCRIPTION
      With this function you can add a Microsoft Sentinel Workspace Manager Member
      .PARAMETER WorkspaceName
      Enter the Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      Enter the name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER targetWorkspaceResourceId
      The ResourceId of the target workspace to add as a member
      .PARAMETER targetWorkspaceTenantId
      The TenantId of the target workspace to add as a member
      .EXAMPLE
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [string]$targetWorkspaceResourceId,

        [Parameter(Mandatory = $false)]
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
                Write-Host $workspaceManagerMemberName
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
                $reponse = $_.Exception.Message
                Write-Output $reponse
            }
        }
        else {
            Write-Host "$($MyInvocation.MyCommand.Name): The Workspace Manager configuration is not 'Enabled' for workspace '$($WorkspaceName)'"
        }
    }
}