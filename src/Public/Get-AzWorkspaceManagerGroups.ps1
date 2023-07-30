function Get-AzWorkspaceManagerGroups {
    <#
      .SYNOPSIS
      Get the Azure Sentinel Workspace Manager Groups
      .DESCRIPTION
      This function gets the Workspace Manager Groups and properties
      .PARAMETER WorkspaceName
      The Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      The name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER Name
      The name of the workspace manager group
      .EXAMPLE
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
        if ($ResourceGroupName) {
            $null = Get-AzWorkspaceManagerConfiguration -WorkspaceName $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManagerConfiguration -WorkspaceName $WorkspaceName
        }

        if ($null -ne $Name) {
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerGroups/$($Name)?api-version=$($SessionVariables.apiVersion)"
        }
        else {
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerGroups?api-version=$($SessionVariables.apiVersion)"
        }
    }

    process {
        if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
            try {
                Write-Verbose "List Azure Sentinel Workspace Manager Groups for workspace [$WorkspaceName)]"

                $requestParam = @{
                    Headers = $authHeader
                    Uri     = $uri
                    Method  = 'GET'
                }
                if ($Name) {
                    $apiResponse = (Invoke-RestMethod @requestParam)
                } 
                else {
                    $apiResponse = (Invoke-RestMethod @requestParam).value
                }

                if ($apiResponse -ne '') {
                    foreach ($object in $apiResponse) {
                        $split = $object.id.Split('/')
                        $result += @(
                            [ordered]@{
                                Name              = $split[-1]
                                ResourceGroupName = $split[-9]
                                ResourceType      = '{0}/{1}' -f $split[-3], $split[-2]
                                ResourceId        = $object.id
                                Tags              = $object.tags
                                Properties        = $object.properties
                            } | ConvertTo-Json -Depth 20 | ConvertFrom-Json -Depth 20
                        )
                    }
                    
                    return $result
                }
                else {
                    Write-Output "$($MyInvocation.MyCommand.Name): No Workspace Manager Group(s) found for workspace [$($WorkspaceName)]"
                }
            }
            catch {
                $reponse = $_.Exception.Message
                Write-Output $reponse
            }
        }
        else {
            Write-Host "$($MyInvocation.MyCommand.Name): The Workspace Manager configuration is not 'Enabled' for workspace '$($WorkspaceName)'"
        }
    }
}