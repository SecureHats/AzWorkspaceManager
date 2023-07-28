function Set-AzWorkspaceManager {
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
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [string]$WorkspaceConfigurationName,

        [Parameter(Mandatory = $false)]
        [bool]$Enabled
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
        $apiVersion = '2023-06-01-preview'
        
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
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations/$($Name)?api-version=$apiVersion"
                
                $requestParam = @{
                    Headers     = $authHeader
                    Uri         = $uri
                    Method      = 'PUT'
                    Body        = $payload
                    ContentType = 'application/json'
                }
                # else {
                #     Write-Verbose "Disable Azure Sentinel Workspace Manager Configuration for workspace [$Name)]"
                #     $requestParam = @{
                #         Headers = $authHeader
                #         Uri     = $uri
                #         Method  = 'DELETE'
                #     }
                # }
                
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