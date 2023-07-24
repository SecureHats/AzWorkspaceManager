function Set-AzWorkspaceManager {
    <#
      .SYNOPSIS
      Enable Azure Sentinel Workspace Manager
      .DESCRIPTION
      With this function you can enable Azure Sentinel Workspace Manager
      .PARAMETER Name
      Enter the Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      Enter the name of the ResouceGroup where the log analytics workspace is located
      .EXAMPLE
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [string]$WorkspaceConfigurationName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [boolean]$Enabled = $true
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
        if ($ResourceGroupName) {
            $null = Get-LogAnalyticsWorkspace -Name $Name -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-LogAnalyticsWorkspace -Name $Name
        }
    }

    process {
        #Region Set Constants
        $apiVersion = '2023-06-01-preview'
        
        if ($Enabled) {
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
        #EndRegion Set Constants

        try {
            if ($SessionVariables.workspace) {
                Write-Verbose "Enabling Azure Sentinel Workspace Manager Configuration for workspace [$Name)]"
                if ($WorkspaceConfigurationName) { Write-Host $WorkspaceConfigurationName }
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/$($Name)?api-version=$apiVersion"
                
                if ($Enable) {
                    $requestParam = @{
                        Headers     = $authHeader
                        Uri         = $uri
                        Method      = 'PUT'
                        Body        = $payload
                        ContentType = 'application/json'
                    }
                }
                else {
                    $requestParam = @{
                        Headers = $authHeader
                        Uri     = $uri
                        Method  = 'DELETE'
                    }
                }
                
                $reponse = Invoke-RestMethod @requestParam
                return $reponse
            }
            else {
                Write-Host "$($MyInvocation.MyCommand.Name): No valid workspace found"
            }
        }
        catch {
            $reponse = $_.Exception.Message
            Write-Output $reponse
        }
    }
}