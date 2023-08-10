function Get-AzWorkspaceManagerItem {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage = "It does not match expected pattern '{1}'")]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [ValidateSet('AlertRules', 'SavedSearches', 'AutomationRules')]
        [string]$Type = 'AlertRules'

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

        if ($Name) {
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/$($Type)/$($Name)?api-version=$($SessionVariables.apiVersion)"
        }
        else {
            if ($Type -eq 'SavedSearches') {
                $uri = "$($SessionVariables.workspace)/savedsearches?api-version=2022-10-01"
            }
            else {
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/$($Type)?api-version=$($SessionVariables.apiVersion)"
            }
        }

        if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
            try {
                $requestParam = @{
                    Headers       = $authHeader
                    Uri           = $uri
                    Method        = 'GET'
                    ErrorVariable = 'ErrVar'
                }

                if ($Name) {
                    $apiResponse = (Invoke-RestMethod @requestParam)
                }
                else {
                    $apiResponse = (Invoke-RestMethod @requestParam).value
                }

                if ($apiResponse -ne '') {
                    $result = @()
                    Foreach ($item in $apiResponse) {
                        $result += [ordered]@{
                            Name          = $item.Properties.DisplayName
                            ResourceId    = $item.Id
                            WorkspaceName = $WorkspaceName
                        } | ConvertTo-Json | ConvertFrom-Json
                    }
                    return $result
                }
                else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) "No $($Type) where found in workspace '$WorkspaceName'" -Severity 'Information'
                    break
                }
            }
            catch {
                Write-Output $_.Exception
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $($_.Exception) -Severity 'Error'
            }
        }
        else {
            Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "The Workspace Manager configuration is not 'Enabled' for workspace '$WorkspaceName'" -Severity 'Information'
        }
    }
    <#
        .SYNOPSIS
        Gets a Microsoft Sentinel Workspace Manager Member
        .DESCRIPTION
        The Get-AzWorkspaceManagerItem is a helper command to get the resource ids of Microsoft Sentinel resources that can be added to assignments
        Currently only three types of resources are supported: AlertRules, AutomationRules and SavedSearches. When using SavedSearches, the Name parameter
        This command currently not supports pipeline input and is still in development.
        is ignored due to API limitations.
        .PARAMETER WorkspaceName
        Enter the Name of the log analytics workspace
        .PARAMETER ResourceGroupName
        Enter the name of the ResouceGroup where the log analytics workspace is located
        .PARAMETER Name
        Enter the name of the resource to get
        .PARAMETER Type
        Select the type of resource to get. Currently only AlertRules, AutomationRules and SavedSearches are supported
        .EXAMPLE
        Get-AzWorkspaceManagerItem -WorkspaceName 'MyWorkspace' -ResourceGroupName 'MyResourceGroup' -Name 'MyAlertRule' -Type 'AlertRules'

        This example gets the resource id of the AlertRule 'MyAlertRule' in the log analytics workspace 'MyWorkspace' in the resource group 'MyResourceGroup'
        .EXAMPLE
        Get-AzWorkspaceManagerItem -WorkspaceName 'MyWorkspace' -ResourceGroupName 'MyResourceGroup' -Type 'AlertRules'

        This example gets the resource ids of all AlertRules in the log analytics workspace 'MyWorkspace' in the resource group 'MyResourceGroup'
        .EXAMPLE
        Get-AzWorkspaceManagerItem -WorkspaceName 'MyWorkspace' -ResourceGroupName 'MyResourceGroup' -Type 'SavedSearches'

        This example gets the resource ids of all SavedSearches in the log analytics workspace 'MyWorkspace' in the resource group 'MyResourceGroup'
        .EXAMPLE
        Get-AzWorkspaceManagerItem -WorkspaceName 'MyWorkspace' -ResourceGroupName 'MyResourceGroup' -Type 'AutomationRules'

        This example gets the resource ids of all AutomationRules in the log analytics workspace 'MyWorkspace' in the resource group 'MyResourceGroup'
        .NOTES
        This command currently not supports pipeline input and is still in development.
    #>
}