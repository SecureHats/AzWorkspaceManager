function Get-LogAnalyticsWorkspace {
    <#
    .SYNOPSIS
    Get the Log Analytics workspace properties
    .DESCRIPTION
    This function is used to get the Log Analytics workspace properties
    .EXAMPLE
    Get-LogAnalyticsWorkspace
    .NOTES
    NAME: Get-LogAnalyticsWorkspace
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]+[A-Za-z0-9]$', ErrorMessage = "It does not match expected pattern '{1}'")]
        [string]$Name,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$ResourceGroupName
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
    }
    process {
        #Region Set Constants
        $apiVersion = '2015-11-01-preview'
        #EndRegion Set Constants

        if ($ResourceGroupName) {
            Write-Verbose "Resource Group Name: $ResourceGroupName"
            $uri = "$($SessionVariables.baseUri)/resourcegroups/$ResourceGroupName/providers/Microsoft.OperationalInsights/workspaces?api-version=$apiVersion"
        }
        else {
            Write-Verbose "No Resource Group Name specified"
            $uri = "$($SessionVariables.baseUri)/providers/Microsoft.OperationalInsights/workspaces?api-version=$apiVersion"
        }

        try {
            Write-Verbose "Trying to get the Microsoft Sentinel workspace '$Name'"

            $requestParam = @{
                Headers       = $authHeader
                Uri           = $uri
                Method        = 'GET'
                ErrorVariable = "ErrVar"
            }

            $workspace = (
                Invoke-RestMethod @requestParam -ErrorVariable "ErrVar" ).value | Where-Object { $_.name -eq $Name }

            switch ($workspace.count) {
                { $_ -eq 1 } { $_workspacePath = ("https://management.azure.com$($workspace.id)").ToLower() }
                { $_ -gt 1 } {
                    $SessionVariables.workspace = $null
                    Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "Multiple resource '/Microsoft.OperationalInsights/workspaces/$($Name)' found. Please specify the resourcegroup" -Severity 'Information'
                    break
                }
                { $_ -lt 1 } {
                    $SessionVariables.workspace = $null
                    Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "The Resource '/Microsoft.OperationalInsights/workspaces/$($Name)' was not found." -Severity 'Error'
                }
                Default {}
            }

            if ($null -ne $SessionVariables.workspace) {
                $uri = "$(($_workspacePath).Split('microsoft.')[0])Microsoft.OperationsManagement/solutions/SecurityInsights($($workspace.name))?api-version=2015-11-01-preview"

                try {
                    $requestParam = @{
                        Headers       = $authHeader
                        Uri           = $uri
                        Method        = 'GET'
                        ErrorVariable = "ErrVar"
                    }

                    $_sentinelInstance = Invoke-RestMethod @requestParam
                    if ($_sentinelInstance.properties.provisioningState -eq 'Succeeded') {
                        Write-Verbose "Microsoft Sentinel workspace [$($Name)] found"
                        $SessionVariables.workspace = "https://management.azure.com$($workspace.id)"
                    }
                    else {
                        $SessionVariables.workspace = $null
                        Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "Microsoft Sentinel was found under workspace '$Name' but is not yet provisioned." -Severity 'Information'
                    }
                }
                catch {
                    $SessionVariables.workspace = $null
                    if ($ErrVar.Message -like '*ResourceNotFound*') {
                        Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "Microsoft Sentinel was not found under workspace '$Name'." -Severity 'Error'
                    }
                    else {
                        Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "An error has occured requesting the Log Analytics workspace." -Severity 'Error'
                    }
                }
            }
        }
        catch {
            $SessionVariables.workspace = $null
            if ($ErrVar.Message -like '*ResourceGroupNotFound*') {
                Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "Provided resource group does not exist." -Severity 'Error'
            }
            else {
                Write-Message -FunctionName $MyInvocation.MyCommand.Name -Message "An error has occured requesting the Log Analytics workspace" -Severity 'Error'
            }
        }
    }
}