function Add-AzWorkspaceManagerGroup {
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
        [ValidateNotNullOrEmpty()]
        [Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters.ResourceGroupCompleterAttribute()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true, ValueFromPipeline = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9]+( [A-Za-z0-9-]+[A-Za-z0-9])*$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$Name,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [string]$Description = "",

        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [array]$workspaceManagerMembers,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters.ResourceIdCompleter(
            "Microsoft.OperationalInsights/workspaces"
        )][array]$ResourceId

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
            foreach ($resource in $ResourceId) {
                $workspaceManagerMembers += $resource.split('/')[-1]
            }
        }
        $payload = @{
            properties = @{
                displayName         = $Name
                description         = $Description
                memberResourceNames = @(foreach ($workspaceManagerMember in $workspaceManagerMembers) { $workspaceManagerMember })
            }
        } | ConvertTo-Json

        if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
            try {
                Write-Verbose "Adding Workspace Manager Group to workspace [$WorkspaceName)]"
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerGroups/$($Name.Replace(' ', '-'))?api-version=$($SessionVariables.apiVersion)"

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
        The Add-AzWorkspaceManagerGroup cmdlet adds a workspace manager group to the configuration.
        It is possible to add child workspaces to the group or add them later. For adding child
        workspaces, use the Add-AzWorkspaceManagerMember cmdlet.
        .PARAMETER WorkspaceName
        The Name of the log analytics workspace.
        .PARAMETER ResourceGroupName
        The name of the ResouceGroup where the log analytics workspace is located.
        .PARAMETER Name
        The name of the workspace manager group.
        If an name is provided with spaces in it, the name will be converted to a name without spaces.
        The display name will be the name with spaces.
        .PARAMETER Description
        The description of the workspace manager group. If not specified, the name will be used.
        .PARAMETER workspaceManagerMembers
        The workspace manager members to add to the group. The members are workspaces that are linked to the workspace manager configuration. and used to provision Microsoft Sentinel workspaces.
        .EXAMPLE
        Add-AzWorkspaceManagerGroup -WorkspaceName "myWorkspace" -Name "Banks" -workspaceManagerMembers 'myChildWorkspace(***)'

        This example adds a Workspace Manager Group 'Banks' to the workspace and adds a child workspace to the group.
        .EXAMPLE
        Get-AzWorkspaceManagerMember -WorkspaceName "myWorkspace" | Add-AzWorkspaceManagerGroup -Name "Banks"

        This example adds a Workspace Manager Group 'Banks' to the workspace and adds all child workspaces to the group using the pipeline.
        .LINK
        Get-AzWorkspaceManagerGroup
        Remove-AzWorkspaceManagerGroup
        Add-AzWorkspaceManagerMember
        Get-AzWorkspaceManagerMember
    #>
}