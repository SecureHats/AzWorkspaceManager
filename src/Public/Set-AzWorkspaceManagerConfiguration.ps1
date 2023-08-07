function Set-AzWorkspaceManagerConfiguration {
    <#
      .SYNOPSIS
      Set Microsoft Sentinel Workspace Manager
      .DESCRIPTION
      With this function you can set the Microsoft Sentinel Workspace Manager
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