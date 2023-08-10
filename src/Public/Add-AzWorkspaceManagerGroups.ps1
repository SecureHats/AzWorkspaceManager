function Add-AzWorkspaceManagerGroups {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$Name,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$Description = "",

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [array]$workspaceManagerMembers

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

        $payload = @{
            properties = @{
                displayName         = $Name
                description         = $Description
                memberResourceNames = @(foreach ($workspaceManagerMember in $workspaceManagerMembers) { $workspaceManagerMember })
            }
        } | ConvertTo-Json

        write-host $payload
        if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
            try {
                Write-Verbose "Adding Workspace Manager Group to workspace [$WorkspaceName)]"
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerGroups/$($Name)?api-version=$($SessionVariables.apiVersion)"
                write-host $uri

                $requestParam = @{
                    Headers     = $authHeader
                    Uri         = $uri
                    Method      = 'PUT'
                    Body        = $payload
                    ContentType = 'application/json'
                }

                $apiResponse = Invoke-RestMethod @requestParam

                if ($apiResponse -ne '') {
                    $result = Format-Result -Message $apiResponse
                    return $result
                }
                else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $($_.Exception.Message) -Severity 'Error'
                }
            }
            catch {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $($_.Exception.Message) -Severity 'Error'
            }
        }
        else {
            Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "The Workspace Manager configuration is not 'Enabled' for workspace '$($WorkspaceName)'" -Severity 'Information'
        }
    }
    <#
      .SYNOPSIS
        Add a Microsoft Sentinel Workspace Manager Group.
      .DESCRIPTION
        The Add-AzWorkspaceManagerGroups cmdlet adds a workspace manager group to the configuration.
        It is possible to add child workspaces to the group or add them later. For adding child
        workspaces, use the Add-AzWorkspaceManagerMembers cmdlet.
      .PARAMETER WorkspaceName
        The Name of the log analytics workspace.
      .PARAMETER ResourceGroupName
        The name of the ResouceGroup where the log analytics workspace is located.
      .PARAMETER Name
        The name of the workspace manager group.
      .PARAMETER Description
        The description of the workspace manager group. If not specified, the name will be used.
      .PARAMETER workspaceManagerMembers
        The workspace manager members to add to the group. The members are workspaces that are linked to the workspace manager configuration. and used to provision Microsoft Sentinel workspaces.
      .EXAMPLE
        Add-AzWorkspaceManagerGroups -WorkspaceName "myWorkspace" -Name "Banks" -workspaceManagerMembers 'myChildWorkspace(***)'

        This example adds a Workspace Manager Group 'Banks' to the workspace and adds a child workspace to the group.
      .EXAMPLE
        $workspaceManagerMembers = @('myChildWorkspace(***)', 'myOtherWorkspace(***)')
        PS > Add-AzWorkspaceManagerGroups -WorkspaceName "myWorkspace" -Name "Banks" -Description "Group of all financial and banking institutions" -workspaceManagerMembers $workspaceManagerMembers'

        This example adds a Workspace Manager Group 'Banks' to the workspace and adds an array of child workspaces to the group.
       .LINK
        Get-AzWorkspaceManagerGroups
        Remove-AzWorkspaceManagerGroups
        Add-AzWorkspaceManagerMembers
        Get-AzWorkspaceManagerMembers
    #>
}