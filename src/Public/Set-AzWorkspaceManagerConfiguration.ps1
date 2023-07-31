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
        [string]$Name,

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
            $null = Get-LogAnalyticsWorkspace -Name $Name -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-LogAnalyticsWorkspace -Name $Name
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
                Write-Host "$($MyInvocation.MyCommand.Name): No valid workspace found"
            }
        }
        catch {
            $reponse = $_.Exception.Message
            Write-Output $reponse
        }
    }
}