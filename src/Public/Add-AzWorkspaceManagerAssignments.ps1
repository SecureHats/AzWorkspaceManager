function Add-AzWorkspaceManagerAssignments {
    <#
      .SYNOPSIS
      Adds a Microsoft Sentinel Workspace Manager Group
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
      .PARAMETER ResourceId
      The ResourceId's of the items that to be added to the Workspace Manager Assignment. This can be a single value or an array of values.
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
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,
        
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [ValidateNotNullOrEmpty()]
        [string]$GroupName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
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
            $null = Get-AzWorkspaceManager -WorkspaceName $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManager -WorkspaceName $WorkspaceName
        }
        
        $payload = @{
            properties = @{
                targetResourceName = $GroupName
                items              = @()
            }
        }
        if ($ResourceId) {
            foreach ($id in $ResourceId) {
                $items = [PSCustomObject]@{
                    resourceId = $id
                }  
                $payload.properties.items += $items
            }
        }

        if (-Not($Name)) { $name = $GroupName }

        Write-Output $payload | ConvertTo-Json -Depth 10 -Compress
        if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
            try {
                Write-Verbose "Adding Workspace Manager Assignment to group '$GroupName'"
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerAssignments/$($name)?api-version=$($SessionVariables.apiVersion)"
                write-host $uri

                $requestParam = @{
                    Headers       = $authHeader
                    Uri           = $uri
                    Method        = 'PUT'
                    Body          = $payload | ConvertTo-Json -Depth 10 -Compress
                    ContentType   = 'application/json'
                    ErrorVariable = 'ErrVar'
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
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $_.Exception.Message -Severity 'Error'
                }
            }
        }
        else {
            Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "The Workspace Manager configuration is not 'Enabled' for workspace '$($WorkspaceName)'" -Severity 'Information'
        }
    }
}
#  /subscriptions/7570c6f7-9ca9-409b-aeaf-cb0f5ac1ad50/resourceGroups/dev-sentinel/providers/Microsoft.OperationalInsights/workspaces/sentinel-playground/providers/Microsoft.SecurityInsights/alertRules/95204744-39a6-4510-8505-ef13549bc0da