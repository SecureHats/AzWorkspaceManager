function Add-AzWorkspaceManagerAssignment {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters.ResourceNameCompleterAttribute(
            "Microsoft.OperationalInsights/workspaces",
            "ResourceGroupName"
        )][string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()][Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters.ResourceGroupCompleterAttribute()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true, ValueFromPipeline = $false)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [ValidateNotNullOrEmpty()]
        [string]$GroupName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [array]$Name,

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

        if ($ResourceId) {
            foreach ($resource in $ResourceId) {
                $items += @(
                    @{ resourceId = $resource }
                )
            }
        }

        $payload = @{
            properties = @{
                targetResourceName = $GroupName
            }
        }

        if ($items ) {
            $payload.properties.items = @($items)
        }

        if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
            try {
                Write-Verbose "Adding Workspace Manager Assignment to group '$GroupName'"
                if (-Not($Name)) { $name = $GroupName }
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerAssignments/$($name)?api-version=$($SessionVariables.apiVersion)"

                $requestParam = @{
                    Headers         = $authHeader
                    Uri             = $uri
                    Method          = 'PUT'
                    Body            = $payload | ConvertTo-Json -Depth 10 -Compress
                    ContentType     = 'application/json'
                    UseBasicParsing = $true
                    ErrorVariable   = 'ErrVar'
                }

                $apiResponse = Invoke-RestMethod @requestParam
                if ($Name) {
                    $apiResponse = (Invoke-RestMethod @requestParam)
                }
                else {
                    $apiResponse = (Invoke-RestMethod @requestParam).value
                }

                if ($apiResponse -ne '') {
                    $result = Format-Result -Message $apiResponse
                        return $result
                }
                else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $($_.Exception.Message) -Severity 'Error'
                    break
                }
            }
            catch {
                if ($ErrVar.Message -like '*existing Assignment*') {
                    Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message (($ErrVar.ErrorRecord) | ConvertFrom-Json).error.message -Severity 'Error'
                }
                else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message (($ErrVar.ErrorRecord) | ConvertFrom-Json).error.message -Severity 'Error'
                }
            }
        }
        else {
            Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "The Workspace Manager configuration is not 'Enabled' for workspace '$($WorkspaceName)'" -Severity 'Information'
        }
    }
    <#
      .SYNOPSIS
      Adds a Microsoft Sentinel Workspace Manager Assignment
      .DESCRIPTION
      The Add-AzWorkspaceManagerAssignment command adds a Workspace Manager Assignment to a Workspace Manager Group.
      These assignments are used to provision Microsoft Sentinel workspaces. The Workspace Manager Assignment name is constructed by the GroupName.
      The resource id's of the items that are added to the assignment are stored in the properties of the assignment. These resources need to be in the same instance as the workspace manager configuration.
      If the resource id's are not in the same instance as the workspace manager configuration, the assignment will not be created and an error will be thrown.
      .PARAMETER WorkspaceName
      The name of the log analytics workspace
      .PARAMETER ResourceGroupName
      The name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER GroupName
      The name of the workspace manager group
      .PARAMETER Name
      The name of the workspace manager assignment
      .PARAMETER ResourceId
      The ResourceId's of the items that to be added to the Workspace Manager Assignment. This can be a single value or an array of values.
      .EXAMPLE
      Add-AzWorkspaceManagerAssignment -WorkspaceName "myWorkspace" -Name "AlertRules" -GroupName 'myGroup'

      This example adds a Workspace Manager Assignment to the workspace with the name 'AlertRules' and assigns this to the group 'myGroup'.
      .EXAMPLE
      Add-AzWorkspaceManagerAssignment -WorkspaceName "myWorkspace" -Name "AlertRules" -GroupName 'myGroup' -ResourceId "/subscriptions/***/resourceGroups/dev-sentinel/providers/Microsoft.OperationalInsights/workspaces/myWorkspace/providers/Microsoft.SecurityInsights/alertRules/95204744-39a6-4510-8505-ef13549bc0da"

      This example adds a Workspace Manager Assignment to the workspace with the name 'AlertRules' and assigns this to the group 'myGroup' and adds the alert rule to the assignment.
      .EXAMPLE
      Get-AzWorkspaceManagerItem -WorkspaceName "myWorkspace" -Type "AlertRules" | Add-AzWorkspaceManagerAssignment -GroupName 'myGroup'

      This example gets all the alert rules from the workspace with the name 'myWorkspace' and adds these to the Workspace Manager Assignment with the name 'AlertRules'.
      .LINK
      Get-AzWorkspaceManagerItem
      Get-AzWorkspaceManagerAssignment
      Remove-AzWorkspaceManagerAssignment
      Get-AzWorkspaceManagerGroup
    #>
}