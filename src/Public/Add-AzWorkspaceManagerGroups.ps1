function Add-AzWorkspaceManagerGroups {
    <#
      .SYNOPSIS
      Get the Azure Sentinel Workspace Manager Groups
      .DESCRIPTION
      This function gets the Workspace Manager Groups and properties
      .PARAMETER WorkspaceName
      The name of the log analytics workspace
      .PARAMETER ResourceGroupName
      The name of the ResouceGroup where the log analytics workspace is located
      .PARAMETER Name
      The name of the workspace manager group
      .PARAMETER Description
      The description of the workspace manager group
      .PARAMETER workspaceManagerMembers
      The name of the workspace manager member(s) to add to the workspace manager group
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
        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [array]$workspaceManagerMembers


    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
        if ($ResourceGroupName) {
            $null = Get-AzWorkspaceManagerConfiguration -WorkspaceName $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManagerConfiguration -WorkspaceName $WorkspaceName
        }
        if ($null -eq $Description) { $Description = $Name }
    }

    process {
        $payload = @{
            properties = @{
                displayName         = $Name
                description         = $Description
                memberResourceNames = @(
                    $workspaceManagerMembers
                )
            }
        } | ConvertTo-Json

        write-host $payload
        if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
            try {
                Write-Verbose "Adding Workspace Manager Group to workspace [$WorkspaceName)]"
                $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerGroups/$($Name)?api-version=$($SessionVariables.apiVersion)"
                write-host $uri

                $requestParam = @{
                    Headers     = $authHeader
                    Uri         = $uri
                    Method      = 'PUT'
                    Body        = $payload
                    ContentType = 'application/json'
                }
                
                $apiResponse = Invoke-RestMethod @requestParam
                
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
                    Write-Output "$($MyInvocation.MyCommand.Name): $_.Exception.Message"
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