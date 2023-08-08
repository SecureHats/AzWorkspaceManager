function Set-AzWorkspaceManager {
    <#
      .SYNOPSIS
          Creates a Workspace Manager Configuration
      .DESCRIPTION
          The Set-AzWorkspaceManager cmdlet creates a Workspace Manager Configuration that is required to use workspace manager feature.
          You can create a workspace manager configuration by using just a workspacename. The minimum requirement to to enable the 
          workspace manager is that Microsoft Sentinel is enabled on the Log Analytics workspace.
          Only one workspace manager configuration can be added per Microsoft Sentinel instance.
      .PARAMETER Name
          Name of the log analytics workspace
      .PARAMETER ResourceGroupName
          Name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER Mode
          Status of the Workspace Manager (Enabled or Disabled)
      .EXAMPLE: Create Workspace Manager on a Sentinel workspace 
          Set-AzWorkspaceManager -Name 'myWorkspace'

          This command creates / enables the workspace manager on the Sentinel workspace 'myWorkspace'
      .EXAMPLE: Disable the Workspace Manager on a Sentinel Workspace 
          Set-AzWorkspaceManager -Name 'myworkspace' -Mode 'Disabled'

          This command sets the workspace manager to disabled.
      .EXAMPLE: Enable a Workspace Manager in the specified resourcegroup
          Set-AzWorkspaceManager -Name 'myWorkspace' -ResourceGroupName 'myRG'

          This command enables the workspace manager for the workspace 'myWorkspace' in resource group 'myRg'
          Specifying the resource group is only needed if multiple workspaces with the same name are available in the subscription.
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$Name,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateSet("Enabled", "Disabled")]
        [string]$Mode = 'Enabled'
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
    }

    process {
        if ($ResourceGroupName) {
            Get-LogAnalyticsWorkspace -Name $Name -ResourceGroupName $ResourceGroupName
        }
        else {
            Get-LogAnalyticsWorkspace -Name $Name
        } 
        
        $payload = @{
            properties = @{
                mode = "$Mode"
            }
        } | ConvertTo-Json -Compress

        Write-Debug $payload
        try {
            if ($SessionVariables.workspace) {
                Write-Verbose "Configuring Microsoft Sentinel Workspace Manager Configuration for workspace [$Name]"
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/$($Name)?api-version=$($SessionVariables.apiVersion)"
                Write-Host $uri
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
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "Error configuring Workspace Manager for workspace $($Name)" -Severity 'Error'
            }
        }
        catch {
            Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $ErrVar  -Severity 'Error'
        }
    }
}
