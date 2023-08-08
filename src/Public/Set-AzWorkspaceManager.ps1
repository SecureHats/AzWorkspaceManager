function Set-AzWorkspaceManager {
    <#
      .SYNOPSIS
      Set Microsoft Sentinel Workspace Manager
      .DESCRIPTION
      With this function you can set the Microsoft Sentinel Workspace Manager
      .PARAMETER Name
      Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      Name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER Mode
      Status of the Workspace Manager (Enabled or Disabled)
      .EXAMPLE
      Set-AzWorkspaceManager -Name 'workspaceName' -ResourceGroupName 'resourceGroupName' -Mode 'Enabled'
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateSet("Enabled", "Disabled")]
        [string]$Mode
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
    }

    process {
        if ($ResourceGroupName) {
            Get-LogAnalyticsWorkspace -Name $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            Get-LogAnalyticsWorkspace -Name $WorkspaceName
        } 
        
        $payload = @{
            properties = @{
                mode = $Mode
            }
        } | ConvertTo-Json

        try {
            if ($SessionVariables.workspace) {
                Write-Verbose "Configuring Microsoft Sentinel Workspace Manager Configuration for workspace [$WorkspaceName]"
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/$($Name)?api-version=$($SessionVariables.apiVersion)"
                
                $requestParam = @{
                    Headers       = $authHeader
                    Uri           = $uri
                    Method        = 'PUT'
                    Body          = $payload
                    ContentType   = 'application/json'
                    ErrorVariable = "ErrVar"
                }

                $apiResponse = Invoke-RestMethod @requestParam
                $result = Format-Result -Message $apiResponse
                return $result
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "Error configuring Workspace Manager for workspace $($WorkspaceName)" -Severity 'Error'
            }
        }
        catch {
            Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $ErrVar  -Severity 'Error'
        }
    }
}