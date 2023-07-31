function Get-AzWorkspaceManagerMembers {
    <#
      .SYNOPSIS
      Add a Microsoft Sentinel Workspace Manager Member
      .DESCRIPTION
      With this function you can add a Microsoft Sentinel Workspace Manager Member
      .PARAMETER WorkspaceName
      Enter the Name of the log analytics workspace
      .PARAMETER ResourceGroupName
      Enter the name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER Name
      Enter the name of the workspace manager member
      .EXAMPLE
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$ResourceGroupName
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
        if ($ResourceGroupName) {
            $null = Get-AzWorkspaceManagerConfiguration -WorkspaceName $WorkspaceName -ResourceGroupName $ResourceGroupName
        } 
        else {
            $null = Get-AzWorkspaceManagerConfiguration -WorkspaceName $WorkspaceName
        }

        if ($Name) {
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerMembers?api-version=$($SessionVariables.apiVersion)"
        } 
        else {
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerMembers/$($Name)?api-version=$($SessionVariables.apiVersion)"
        }
    }

    process {        
        if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
            try {
                Write-Verbose "Get Workspace Manager Member for workspace [$WorkspaceName)]"        
                $requestParam = @{
                    Headers = $authHeader
                    Uri     = $uri
                    Method  = 'GET'
                }
                
                $apiResponse = (Invoke-RestMethod @requestParam).value
            
                if ($apiResponse -ne '') {
                    $split = $apiResponse.id.Split('/')
                    $result = [ordered]@{
                        Name              = $split[-1]
                        ResourceGroupName = $split[-9]
                        ResourceType      = '{0}/{1}' -f $split[-3], $split[-2]
                        ResourceId        = $apiResponse.id
                        Tags              = $apiResponse.tags
                        Properties        = $apiResponse.properties
                    } | ConvertTo-Json | ConvertFrom-Json
                    return $result
                }
                else {
                    Write-Output "$($MyInvocation.MyCommand.Name): No Workspace Manager Member(s) found for workspace [$($WorkspaceName)]"
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