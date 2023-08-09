function Add-AzWorkspaceManagerGroups {
    <#
      .SYNOPSIS
      Adds a Microsoft Sentinel Workspace Manager Group
      .DESCRIPTION
      This function adds a workspace manager group and adds the child workspaces
      .PARAMETER WorkspaceName
      The name of the log analytics workspace
      .PARAMETER ResourceGroupName
      The name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER Name
      The name of the workspace manager group
      .PARAMETER Description 
      The description of the workspace manager group. If not specified, the name will be used.
      .PARAMETER workspaceManagerMembers
      The name of the workspace manager member(s) to add to the workspace manager group
      .EXAMPLE
      Add-AzWorkspaceManagerGroups -WorkspaceName "myWorkspace" -Name "Banks" -Description "" -workspaceManagerMembers 'myWorkspace(afbd324f-6c48-459c-8710-8d1e1cd03812)'
      Adds a Workspace Manager Group to the workspace with the name 'Banks' and adds a child workspace with the name 'myWorkspace(afbd324f-6c48-459c-8710-8d1e1cd03812)' to the group.
      .EXAMPLE
      Add-AzWorkspaceManagerGroups -WorkspaceName "myWorkspace" -ResourceGroupName 'MyRg' -Name "Banks" -Description "Group of all financial and banking institutions" -workspaceManagerMembers @('myWorkspace(afbd324f-6c48-459c-8710-8d1e1cd03812)', 'otherWorkspace(f5fa104e-c0e3-4747-9182-d342dc048a9e)')
      Adds a Workspace Manager Group to the workspace and adds multiple child workspaces to the group.
    #>
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
}