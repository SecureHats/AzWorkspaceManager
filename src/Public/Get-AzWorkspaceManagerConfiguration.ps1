function Get-AzWorkspaceManagerConfiguration {
    <#
      .SYNOPSIS
      Get the Microsoft Sentinel Workspace Manager
      .DESCRIPTION
      This function gets the Workspace Manager and returns the properties if enabled
      .PARAMETER WorkspaceName
      The Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      The name of the ResouceGroup where the log analytics workspace is located
      .EXAMPLE
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName
    )

    begin {
        $MyInvocation.MyCommand.Name | Invoke-AzWorkspaceManager
        if ($ResourceGroupName) {
            Get-LogAnalyticsWorkspace -Name $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            Get-LogAnalyticsWorkspace -Name $WorkspaceName
        }
    }

    process {
        try {
            if ($SessionVariables.workspace) {
                Write-Verbose "Get Microsoft Sentinel Workspace Manager Configuration for workspace [$WorkspaceName)]"
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations?api-version=$($SessionVariables.apiVersion)"

                $requestParam = @{
                    Headers = $authHeader
                    Uri     = $uri
                    Method  = 'GET'
                }
                $apiResponse = (Invoke-RestMethod @requestParam).value
            }
            else {
                Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "Microsoft Sentinel was not found under workspace '$WorkspaceName'" -Severity 'Error'
            }
            
            if ($apiResponse -ne '') {
                $SessionVariables.workspaceManagerConfiguration = $apiResponse.properties.mode
                $result = Format-Result -Message $apiResponse
                return $result
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "Workspace Manager is not 'configured' for workspace [$($WorkspaceName)]" -Severity 'Information'
                $SessionVariables.workspaceManagerConfiguration = $false
                break
            }
        }
        catch {
            Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $($_.Exception.Message) -Severity 'Error'
        }
    }
}