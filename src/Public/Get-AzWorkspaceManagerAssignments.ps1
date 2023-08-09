function Get-AzWorkspaceManagerAssignments {
<#
.SYNOPSIS
Get the Microsoft Sentinel Workspace Manager Groups
.DESCRIPTION
This function gets the Workspace Manager Groups and properties
.PARAMETER WorkspaceName
The Name of the log analytics workspace
.PARAMETER ResourceGroupName
The name of the ResouceGroup where the log analytics workspace is located
.PARAMETER Name
The name of the workspace manager assignment
.EXAMPLE
#>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage="It does not match expected pattern '{1}'")]
        [string]$Name
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
    }

    process {
        if ($ResourceGroupName) {
            $null = Get-AzWorkspaceManager -WorkspaceName $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManager -WorkspaceName $WorkspaceName
        }

        if ($null -ne $Name) {
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerAssignments/$($Name)?api-version=$($SessionVariables.apiVersion)"
        }
        else {
            $uri = "$($SessionVariables.workspace)/providers/Microsoft.SecurityInsights/workspaceManagerAssignments?api-version=$($SessionVariables.apiVersion)"
        }
        
        if ($SessionVariables.workspaceManagerConfiguration -eq 'Enabled') {
            try {
                Write-Verbose "List Microsoft Sentinel Workspace Manager Assignments for workspace '$WorkspaceName'"

                $requestParam = @{
                    Headers = $authHeader
                    Uri     = $uri
                    Method  = 'GET'
                    ErrorVariable = 'ErrVar'
                }
                
                if ($Name) {
                    $apiResponse = (Invoke-RestMethod @requestParam)
                } 
                else {
                    $apiResponse = (Invoke-RestMethod @requestParam).value
                }

                if ($apiResponse -ne '') {
                    foreach ($object in $apiResponse) {
                        $result = Format-Result -Message $apiResponse
                    }
                    
                    return $result
                }
                else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "No Workspace Manager Assignments found for workspace '$WorkspaceName'" -Severity 'Information'
                }
            }
            catch {
                if ($ErrVar.Message -like '*ResourceNotFound*') {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "No Workspace Manager Assignments with name '$($Name)' found under workspace '$WorkspaceName'" -Severity 'Error'
                }
                else {
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message $($_.Exception.Message) -Severity 'Error'
                }
            }
        }
        else {
            Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "The Workspace Manager configuration is not 'Enabled' for workspace '$WorkspaceName'" -Severity 'Information'
        }
    }
}