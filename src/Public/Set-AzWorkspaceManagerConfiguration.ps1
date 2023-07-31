function Set-AzWorkspaceManagerConfiguration {
    <#
      .SYNOPSIS
      Set Azure Sentinel Workspace Manager
      .DESCRIPTION
      With this function you can set the Azure Sentinel Workspace Manager
      .PARAMETER Name
      Enter the Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      Enter the name of the ResouceGroup where the log analytics workspace is located
      .EXAMPLE
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$WorkspaceConfigurationName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [bool]$Enabled
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
        if ($ResourceGroupName) {
            Get-LogAnalyticsWorkspace -Name $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            Get-LogAnalyticsWorkspace -Name $WorkspaceName
        }
    }

    process {
        if ($Enabled -eq $true) {
            $mode = 'Enabled'
        }
        else {
            $mode = 'Disabled'
        }
        
        $payload = @{
            properties = @{
                mode = $mode
            }
        } | ConvertTo-Json

        try {
            if ($SessionVariables.workspace) {
                Write-Verbose "Configuring Azure Sentinel Workspace Manager Configuration for workspace [$Name)]"
                if ($WorkspaceConfigurationName) { $Name = $WorkspaceConfigurationName }
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/$($Name)?api-version=$($SessionVariables.apiVersion)"
                
                $requestParam = @{
                    Headers     = $authHeader
                    Uri         = $uri
                    Method      = 'PUT'
                    Body        = $payload
                    ContentType = 'application/json'
                }

                $reponse = Invoke-RestMethod @requestParam
                return $reponse
            }
            else {
                Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "Error configuring Workspace Manager for workspace $($WorkspaceName)" -Severity 'Error'
                break
            }
        }
        catch {
            $reponse = $_.Exception.Message
            Write-Message -FunctionName 
        }
    }
}