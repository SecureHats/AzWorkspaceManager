function Get-AzWorkspaceManagerAssignments {
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
            $null = Get-AzWorkspaceManager -Name $WorkspaceName -ResourceGroupName $ResourceGroupName
        }
        else {
            $null = Get-AzWorkspaceManager -Name $WorkspaceName
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
                    Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message (($ErrVar.ErrorRecord) | ConvertFrom-Json).error.message -Severity 'Error'
                }
            }
        }
        else {
            Write-Message -FunctionName $($MyInvocation.MyCommand.Name) -Message "The Workspace Manager configuration is not 'Enabled' for workspace '$WorkspaceName'" -Severity 'Information'
        }
    }
    <#
        .SYNOPSIS
        Get the Microsoft Sentinel Workspace Manager Groups
        .DESCRIPTION
        The Get-AzWorkspaceManagerAssignments cmdlet gets the Microsoft Sentinel Workspace Manager Assignments by just specifying the workspace name
        When the workspace manager configuration is not 'Enabled' for the workspace, the cmdlet will return an information message
        If a Name is specified, the cmdlet will return the details of the workspace manager assignment
        .PARAMETER WorkspaceName
        The Name of the log analytics workspace
        .PARAMETER ResourceGroupName
        The name of the ResouceGroup where the log analytics workspace is located
        .PARAMETER Name
        The name of the workspace manager assignment
        .EXAMPLE
        Get-AzWorkspaceManagerAssignments -WorkspaceName 'MyWorkspace'

        This example gets all the Microsoft Sentinel Workspace Manager Assignments for the workspace 'MyWorkspace'
        .EXAMPLE
        Get-AzWorkspaceManagerAssignments -WorkspaceName 'MyWorkspace' -Name 'MyWorkspaceManagerAssignment'

        This example gets the details of the Microsoft Sentinel Workspace Manager Assignment 'MyWorkspaceManagerAssignment' for the workspace 'MyWorkspace'
        .LINK
        Add-AzWorkspaceManagerAssignments
        Remove-AzWorkspaceManagerAssignments
    #>
}